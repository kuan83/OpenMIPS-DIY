`include "defines.v"

module inst_rom(

	input wire          	       ce,
	input wire[`InstAddrBus]   addr,  	   // 32-bit instruction address
	
	output reg[`InstBus]       inst        // Read 32-bit instruction
	
);

	reg[`InstBus]  inst_mem[0:`InstMemNum-1];    // 32-bit width x 131071 words depth (not bytes)

	// instAddress 0x0000 0000
	// instruction 34011100: 0011 0100 0000 0001 0001 0001 0000 0000
	// instAddress 0x0000 0004
	// instruction 34020020: 0011 0100 0000 0002 0000 0000 0002 0000	
	//                      |opcode| $rs | $rt  |        imm        |

	initial $readmemh ( "inst_rom.data", inst_mem );	

	// InstMemNum = 131071; Actual address bits used by ROM InstMemNumLog2 = 17  
	// Align addr "byte" to inst_mem "word". Instruction fetch uses words, so divide by 4 (left shift by 2)
	// originally [16:0] for 17 bits, now [18:2] for 17 bits

	always @ (*) begin
		if (ce == `ChipDisable) begin
			inst <= `ZeroWord;
	    end else begin
			inst <= inst_mem[addr[`InstMemNumLog2+1:2]];        
		end                                              	    
	end															

endmodule
