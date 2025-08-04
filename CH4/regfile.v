// Implements 32-bit x 32 registers
// Can simultaneously read 2 registers & write 1 register
// Note:
// R-format
// |  op code   |       rs     |       rt     |      rd      |   shamt   | function |
// |            | 5-bit raddr1 | 5-bit raddr2 | 5-bit waddr  | ...
// I-format
// |  op code   |      rs      |       rt     |             immediate               |
// |            | 5-bit raddr1 |  5-bit waddr | 

`include "defines.v"

module regfile(
    input wire	    	       clk,
    input wire				   rst,

    // Write port
    input wire               we,           // write enable
    input wire [`RegAddrBus] waddr,        // Addrbus width = 5 (2^5 = 32) used to select the register to write to
    input wire [`RegBus]     wdata,        // Databus = 31:0

    // Read port 1
    input wire               re1,          // reg1 enable
    input wire [`RegAddrBus] raddr1,       
    output reg [`RegBus]     rdata1,

    // Read port 2
    input wire               re2,
    input wire [`RegAddrBus] raddr2,
    output reg [`RegBus]     rdata2
);

/***************************************************
*****Section 1: Define 32-bit x 32 Registers *******
***************************************************/
/*
	$0: 		  $zero       
	$1: 		  $at  
	$2-$3:		$v0-$v1  
	$4-$7:  	$a0-$a3
	$8-$15:		$t0-$t7
	$16-$23:	$s0-$s7
	$24-$25:	$t8-$t9
	$26-$27:	$k0-$k1
	$28:		  $gp
	$29:		  $sp
	$30:		  $fp
	$31:		  $ra
*/

reg [`RegBus] regs[0:`RegNum-1];			// `RegNum = 32, width x depth = 32bit x 32 registers

/***************************************************
*********** Section 2: Write Operation ***********
***************************************************/
  // Synchronous write
	// avoid race condition
    always @ (posedge clk) begin
        if (rst == `RstDisable) begin
            if ((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin    // RegNumLog2 = 5 bit. $zero can only be 0, can only be read, not written 
                regs[waddr] <= wdata;
            end
        end
    end

/***************************************************
**** Section 3: Read Operation for Read Port 1 *****
***************************************************/
    // Asynchronous read
    always @ (*) begin
        if (rst == `RstEnable) begin
            rdata1 <= `ZeroWord;
        end else if (raddr1 == `RegNumLog2'h0) begin
            rdata1 <= `ZeroWord;
        end else if ((raddr1 == waddr) && (we == `WriteEnable) && (re1 == `ReadEnable)) begin    // Handle write-after-read hazard
            rdata1 <= wdata;
        end else if (re1 == `ReadEnable) begin        // Normal write situation
            rdata1 <= regs[raddr1];
        end else begin
            rdata1 <= `ZeroWord;
        end
    end

/***************************************************
**** Section 4: Read Operation for Read Port 2 *****
***************************************************/

    always @ (*) begin
        if (rst == `RstEnable) begin
            rdata2 <= `ZeroWord;
        end else if (raddr2 == `RegNumLog2'h0) begin
            rdata2 <= `ZeroWord;
        end else if ((raddr2 == waddr) && (we == `WriteEnable) && (re2 == `ReadEnable)) begin
            rdata2 <= wdata;
        end else if (re2 == `ReadEnable) begin
            rdata2 <= regs[raddr2];
        end else begin
            rdata2 <= `ZeroWord;
        end
    end
    
endmodule
