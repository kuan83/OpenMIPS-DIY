// Pass the results from the memory stage to the write-back (wb) stage on the next clock cycle.

`include "defines.v"

module mem_wb(

	input wire		clk,
	input wire		rst,
	

	// Information from the memory access stage	
	input wire[`RegAddrBus]       mem_wd,
	input wire                    mem_wreg,
	input wire[`RegBus]			  mem_wdata,

	// Information sent to the write-back stage
	output reg[`RegAddrBus]       wb_wd,
	output reg                    wb_wreg,
	output reg[`RegBus]			  wb_wdata	    
	
);

	// Note: This is a sequential logic circuit
	always @ (posedge clk) begin
		if(rst == `RstEnable) begin
			wb_wd <= `NOPRegAddr;
			wb_wreg <= `WriteDisable;
		  wb_wdata <= `ZeroWord;	
		end else begin
			wb_wd <= mem_wd;
			wb_wreg <= mem_wreg;
			wb_wdata <= mem_wdata;
		end    //if
	end      //always
			

endmodule
