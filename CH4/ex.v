// execution stage

`include "defines.v"

module ex(

	input wire					  rst,
	
	// Information passed to the execution stage
	input wire[`AluOpBus]         aluop_i,
	input wire[`AluSelBus]        alusel_i,
	input wire[`RegBus]           reg1_i,
	input wire[`RegBus]           reg2_i,
	input wire[`RegAddrBus]       wd_i,
	input wire                    wreg_i,

	
	output reg[`RegAddrBus]       wd_o,				// wirte destination (address)
	output reg                    wreg_o,
	output reg[`RegBus]			  wdata_o
	
);

	reg[`RegBus] logicout;
	
	
	// Determines the operation based on the aluop_i opcode; currently only performs OR operation or default.
	always @ (*) begin
		if(rst == `RstEnable) begin
			logicout <= `ZeroWord;
		end else begin
			case (aluop_i)
				`EXE_OR_OP:	begin
					logicout <= reg1_i | reg2_i;	// 32'h0000 0000 | 32'h0000 1100 = 32'h0000 1100
				end
				default: begin
					logicout <= `ZeroWord;
				end
			endcase
		end    //if
	end      //always

	// Determines the operation based on the alusel_i function code; currently only performs logical operations or default.
	always @ (*) begin
		wd_o <= wd_i;	 	 	// Address of the destination register to write to
		wreg_o <= wreg_i;		// Whether to write to the destination register
		case ( alusel_i ) 
			`EXE_RES_LOGIC:	begin
				wdata_o <= logicout;
			end
			default:					begin
				wdata_o <= `ZeroWord;
			end
		endcase
	end	

endmodule
