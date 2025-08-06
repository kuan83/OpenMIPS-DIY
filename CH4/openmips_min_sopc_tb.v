// Testbench for the minimal SOPC

`include "defines.v"
`timescale 1ns/1ps

module openmips_min_sopc_tb();

  reg     CLOCK_50;
  reg     rst;
  
  // Generate a clock: signal toggles every 10ns, so the period is 20ns (50MHz).
  initial begin
    CLOCK_50 = 1'b0;
    forever #10 CLOCK_50 = ~CLOCK_50;
  end
        
  // Initially, assert reset.
  // Deassert reset at 195ns.
  // At 1000ns, stop the simulation.
  initial begin
    rst = `RstEnable;
    #195 rst= `RstDisable;
    #1000 $stop;
  end
        
  openmips_min_sopc openmips_min_sopc0(
		.clk(CLOCK_50),
		.rst(rst)	
	);

endmodule
