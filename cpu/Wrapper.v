/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (
	input CLK100MHZ,
	input fake_clock,
	input[15:0] SW,
	output[15:0] LED,
	output JA_1,
	output JA_2,
	input JA_3,
	output JA_4,
	input JA_7,
	input JB_1,
	input JB_2
);
    wire reset = 1'b0;
    wire CLK20MHZ, locked;
//    clk_wiz_0  pll
//     (
//      // Clock out ports
//      .clk_out1(CLK20MHZ),
//      // Status and control signals
//      .reset(reset),
//      .locked(locked),
//     // Clock in ports
//      .clk_in1(CLK100MHZ)
//     );
	// assign CLK20MHZ = CLK100MHZ;
    
	wire clock = CLK100MHZ;
	// wire clock = fake_clock;
	// wire clock = CLK100MHZ;
	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut, RAMDataOut, sensorDataOut;

	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "algorithm_test_takes";
	
	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut)); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB));
	
	wire[31:0] playerBoardOut, cpuBoardOut, kingBoardOut, statusOut;
	SensorManager sensorManager(
		.sensorDataOut(sensorDataOut),
		.clk(clock),
		// .led(LED),
		.sr_clk_wire(JA_1),
		.parallel_mode_wire(JA_2),
		.in_val(JA_3),
		.v1(JB_1),
		.v2(JB_2)
	);
	assign LED = SW[0] ? playerBoardOut[15:0] : SW[1] ? cpuBoardOut[15:0] :  SW[2] ? kingBoardOut[15:0] : SW[3] ? {sensorDataOut[7],sensorDataOut[7],sensorDataOut[7],sensorDataOut[7],sensorDataOut[7], JA_3, JA_2, JA_1, sensorDataOut[7:0]} : instAddr[15:0];
	always @(playerBoardOut, cpuBoardOut, kingBoardOut, statusOut) begin
		$display("%b %b %b %b", playerBoardOut, cpuBoardOut, kingBoardOut, statusOut);
	end
	LightController lightController(
		.clk(clock),
		// .clk(CLK100MHZ),
		.playerPieces(playerBoardOut),
		.cpuPieces(cpuBoardOut),
//		.cpuPieces(32'b00000000000000000000000000000000),
		.kingPieces(kingBoardOut),
//		.playerPieces(32'b00110000000000000000010000000000),
//		.cpuPieces(32'b0),
//		.kingPieces(32'b00000000000000000000000000000000),
		.out(JA_4)
	);

	MemoryManager memoryManager(
		.clock(CLK100MHZ),
		.reset(reset),
		.wEn(mwe),
		.addr(memAddr),
		.dataIn(memDataIn),
		.dataOut(memDataOut),
		.playerBoardOut(playerBoardOut),
		.cpuBoardOut(cpuBoardOut),
		.kingBoardOut(kingBoardOut),
		.statusOut(statusOut),
		.sensorBoardIn(sensorDataOut),
		.buttonPressIn(JA_7)
	);

endmodule
