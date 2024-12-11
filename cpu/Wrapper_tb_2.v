`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to test your processor for functionality.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. 
 * You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v 
 * and memory modules to work with the Wrapper interface as provided.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must set the parameter when compiling to use the memory file of 
 * the test you created using the assembler and load the appropriate 
 * verification file.
 *
 * For example, you would add sample as your parameter after assembling sample.s
 * using the command
 *
 * 	 iverilog -o proc -c FileList.txt -s Wrapper_tb -PWrapper_tb.FILE=\"sample\"
 *
 * Note the backslashes (\) preceding the quotes. These are required.
 *
 **/

module Wrapper_tb_2 #(parameter FILE = "nop");
	// Inputs to the processor
	reg clock = 0, reset = 0;

	// Create the clock
	always
		#10 clock = ~clock; 

	wire [15:0] LED;
	wire [15:0] sw;
	wire JA_1, JA_2, JA_3, JA_4, JA_5, JA_7, JB_1, JB_2, JB_3, JB_4;
	wire fake_clock;

	Wrapper wrapper(
		clock,
		fake_clock,
		sw,
		LED,
		JA_1,
		JA_2,
		JA_3,
		JA_4,
		JA_7,
		JB_1,
		JB_2,
		JB_3,
		JB_4
	);

	initial begin
		#100000;
		$finish;
	end
endmodule