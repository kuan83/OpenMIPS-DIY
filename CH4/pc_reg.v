// Program Counter (PC) increments by 4 in the fetch stage
// The next stage fetches instructions from ROM.
`include "defines.v"

module pc_reg(
    
    input wire      					clk,
    input wire                rst,
	    
	  output reg			        		ce,		// enable rom 
    output reg[`InstAddrBus]   	pc
    
	);
    
    always@ (posedge clk) begin
        if(rst == `RstEnable) begin
            ce <= `ChipDisable;
            end else begin
            ce <= `ChipEnable;
            end
        end        
    
    always @ (posedge clk) begin
        if (ce == `ChipDisable) begin
            pc <= 32'h00000000;
        end else begin
            pc <= pc + 4'h4;
        end
    end        

endmodule
