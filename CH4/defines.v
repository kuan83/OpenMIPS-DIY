//******************** Global Macro Definitions ********************

`define RstEnable           1'b1            // Reset signal active
`define RstDisable          1'b0            // Reset signal inactive
`define ZeroWord            32'h00000000    // 32-bit value 0
`define WriteEnable         1'b1            // Allow writing
`define WriteDisable        1'b0            // Prohibit writing
`define ReadEnable          1'b1            // Allow reading
`define ReadDisable         1'b0            // Prohibit reading
`define AluOpBus            7:0             // Bit width of aluop_o output from decode stage
`define AluSelBus           2:0             // Bit width of alusel_o output from decode stage
`define InstValid           1'b0            // Instruction valid
`define InstInvalid         1'b1            // Instruction invalid
`define True_v              1'b1            // Logical "true"
`define False_v             1'b0            // Logical "false"
`define ChipEnable          1'b1            // Enable chip
`define ChipDisable         1'b0            // Disable chip

//******************** Macro Definitions Related to Specific Instructions ********************

`define EXE_ORI             6'b001101       // Opcode for ori instruction
`define EXE_NOP             6'b000000

//AluOp
`define EXE_OR_OP           8'b00100101		// = hex 25
`define EXE_NOP_OP          8'b00000000

//AluSel
`define EXE_RES_LOGIC       3'b001
`define EXE_RES_NOP         3'b000

//******************** Macro Definitions Related to Instruction Memory (ROM) ********************

`define InstAddrBus         31:0        // Address bus width of ROM
`define InstBus             31:0        // Data bus width of ROM

`define InstMemNum          131071      // Actual size of ROM is 128KB
`define InstMemNumLog2      17          // Actual address line width used by ROM, 2^17 = 131071


//******************** Macro Definitions Related to General Purpose Registers (Regfile) ********************

`define RegAddrBus          4:0         // Address bus width of Regfile module
`define RegBus              31:0        // Data bus width of Regfile module
`define RegWidth            32          // Width of general purpose register
`define DoubleRegWidth      64          // Double the width of general purpose register
`define DoubleRegBus        63:0        // Data bus width for double general purpose register
`define RegNum              32          // Number of general purpose registers
`define RegNumLog2          5           // Number of address bits used to address general purpose registers, 2^5=32
`define NOPRegAddr          5'b00000    // Register address corresponding to no-operation
