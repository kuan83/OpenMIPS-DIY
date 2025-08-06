// Instruction Decode


module id(
    input wire						 rst,
    input wire [`InstAddrBus]		pc_i,    
    input wire [`InstBus]		  inst_i,    // 32-bit instruction

    // Data read from Regfile
    input wire [`RegBus]     reg1_data_i,
    input wire [`RegBus]     reg2_data_i,

    // Control signals output to Regfile, indicating whether data needs to be read from read port 1 or 2. Indicates which register to read.
    output reg           	  reg1_read_o,			// reg1 read enable
    output reg           	  reg2_read_o,
    output reg [`RegAddrBus]  reg1_addr_o,			// 5-bit
    output reg [`RegAddrBus]  reg2_addr_o,

    // Information passed to the execution stage
    output reg [`AluOpBus]  	  aluop_o,			// 8-bit
    output reg [`AluSelBus]  	 alusel_o,			// 8-but
    output reg [`RegBus]		   reg1_o,
    output reg [`RegBus]		   reg2_o,
    output reg [`RegAddrBus]		 wd_o,
    output reg						wreg_o			// 1-bit
);

// Get the instruction's opcode and function code
// For the 'ori' instruction, it can be determined by bits 26-31 (6'b001101)
// I-format
//               
// |  op code  |  rs   |  rt   |       immediate      |
// |  31 - 26  | 25-21 | 20-16 |          15-0        |
// 
// R-format
// |  op code  |  rs   |  rt   |   rd  | shamt | func |
// |  31 - 26  | 25-21 | 20-16 | 15-11 |  10-6 | 5-0  |

wire [5:0] op  = inst_i[31:26];			// op code
wire [4:0] op2 = inst_i[10:6];			// R format Shamt  
wire [5:0] op3 = inst_i[5:0];			// R format function
wire [4:0] op4 = inst_i[20:16];			// R format $rd or I format $rt

// Store the immediate value required for instruction execution
reg [`RegBus] imm;                    // Used to store the 32-bit immediate after sign extension

// Indicates whether the instruction is valid
reg instvalid;

/***************************************************
*********** Section 1: Instruction Decoding ***********
***************************************************/


	always @ (*) begin
		if (rst == `RstEnable) begin
			aluop_o       <= `EXE_NOP_OP;
			alusel_o      <= `EXE_RES_NOP;
			wd_o          <= `NOPRegAddr;
			wreg_o        <= `WriteDisable;
			instvalid     <= `InstValid;
			reg1_read_o   <= 1'b0;
			reg2_read_o   <= 1'b0;
			reg1_addr_o   <= `NOPRegAddr;
			reg2_addr_o   <= `NOPRegAddr;
			imm           <= `ZeroWord;
		end else begin                        // Default values: empty R-format; these will be used if no known instruction type matches
			aluop_o       <= `EXE_NOP_OP;
			alusel_o      <= `EXE_RES_NOP;
			wd_o          <= inst_i[15:11];    // $rd
			wreg_o        <= `WriteDisable;
			instvalid     <= `InstInvalid;
			reg1_read_o   <= 1'b0;
			reg2_read_o   <= 1'b0;
			reg1_addr_o   <= inst_i[25:21];  // Default register address for Regfile read port 1 ($rs)
			reg2_addr_o   <= inst_i[20:16];  // Default register address for Regfile read port 2 ($rt)
			imm           <= `ZeroWord;

			case (op)
				`EXE_ORI: begin   						  // ori (MIPS I-type instruction format)
					wreg_o        <= `WriteEnable;        // The 'ori' instruction writes back to the destination register $rt
					aluop_o       <= `EXE_OR_OP;          // The operation is logical OR, `EXE_OR_OP = 8'b00100101
					alusel_o      <= `EXE_RES_LOGIC;      // The operation type is logical operation, `EXE_RES_LOGIC = 3'b001
					reg1_read_o   <= 1'b1;                // Need to read $rs data from Regfile port 1
					reg2_read_o   <= 1'b0;                // No need to read $rt data from port 2 (because $rt is for write )
					imm           <= {16'h0, inst_i[15:0]}; // Zero extension to 32-bit immediate, imm = 32'h0000 1100
					wd_o          <= inst_i[20:16];       // Write destination register address $rt
					instvalid     <= `InstValid;          // Mark as a valid instruction
				end
				default: begin
				end
			endcase
		end
	end

// Determine which decoded results to output

/***************************************************
*********** Section 2: Determine Operand 1 for Execution ***********
***************************************************/
// instAddress 0x0000 0000
// instruction 34011100: 0011 0100 0000 0001 0001 0001 0000 0000
//                      |opcode| $rs | $rt  |        imme       |

	always @ (*) begin
		if (rst == `RstEnable) begin
			reg1_o <= `ZeroWord;
		end else if (reg1_read_o == 1'b1) begin
			reg1_o <= reg1_data_i;  // Regfile port 1 output value
		end else if (reg1_read_o == 1'b0) begin
			reg1_o <= imm;          // Use immediate
		end else begin
			reg1_o <= `ZeroWord;
		end
	end

/***************************************************
*********** Section 3: Determine Operand 2 for Execution ***********
***************************************************/

	always @ (*) begin
		if (rst == `RstEnable) begin
			reg2_o <= `ZeroWord;
		end else if (reg2_read_o == 1'b1) begin
			reg2_o <= reg2_data_i;  // Regfile port 2 output value
		end else if (reg2_read_o == 1'b0) begin
			reg2_o <= imm;          // Use immediate
		end else begin
			reg2_o <= `ZeroWord;
		end
	end


endmodule
