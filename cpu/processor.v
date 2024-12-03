/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */

module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */

    localparam [4:0] addi = 5'b00101;
    localparam [4:0] bne = 5'b00010;
    localparam [4:0] blt = 5'b00110;
    localparam [4:0] sw = 5'b00111;
    localparam [4:0] lw = 5'b01000;

    localparam [4:0] j = 5'b00001;
    localparam [4:0] jal = 5'b00011;
    localparam [4:0] jr = 5'b00100;
    localparam[4:0] setx = 5'b10101;
    localparam[4:0] bex = 5'b10110;

    localparam[4:0] sur = 5'b10000; // Shift up right - I type
    localparam[4:0] sul = 5'b10001; // Shift up left - I type
    localparam[4:0] sura = 5'b11000; // rd = rs & sur(rt) - R type
    localparam[4:0] sula = 5'b11001; // rd = rs & sul(rt) - R type

    localparam [31:0] nop = 32'b0;

    wire [31:0] progCount_in, progCount_out, temp, pcAddResult, firstIR_out, firstPC_out, secondIn_out, pc_plus, aluReg_in, jumpType_pc, updated_pc, thirdIR_mod, alu_res_withovflow, aluIn2_decision;
    wire [31:0] sxImmediate, mainALU_res, thirdIR_out, fourthIR_out, aluReg_out, aluReg2_out, dmemReg_out, data1_out, data2_out, secondIR_out, secondPC_out, mainALU_in1, mainALU_in2, firstIR_in, secondIR_in; // need to replace temp with the address that we are going to after the branch instruction
    wire [31:0] true_result, multDivRes;

    wire useless, branch, noteq, lessthan, ovflow, ovflow_add, ovflow_addi, ovflow_sub, ovflow_det1, ovflow_det2;
    wire stall_mult, stall_div, stall, ctrl_mult, ctrl_div, ctrl_mult_temp, ctrl_div_temp, data_rdy, data_exp, isMult, isDiv, ovflow_mul, ovflow_div, hazard, dx_load_cond, fd_load_cond, data_condition;
    wire [4:0] destReg, sReg, tReg, aluOP, dReg, branch_op, sReg_two, prev_RegA, prev_RegB, tReg_two, dReg_two;
    assign dx_load_cond = secondIR_out[31:27]==lw;
    assign fd_load_cond = firstIR_out[31:27]==sw;
    assign hazard = (dx_load_cond) && 
    (((secondIR_out[26:22]==ctrl_readRegA) && secondIR_out[26:22]!=5'b0) || (((secondIR_out[26:22]==ctrl_readRegB) && secondIR_out[26:22]!=5'b0) && ~fd_load_cond));

    /****** Fetch stage ********/

    register progCounter(clock, ~stall & ~hazard, progCount_in, reset, progCount_out);
    alu pcAdd(progCount_out, {31'b0, 1'b1}, 5'b0, 5'b0, pcAddResult, useless, useless, useless); // what happens on pc overflow?
    assign progCount_in = branch ? temp : pcAddResult;

    assign address_imem = progCount_out;
    assign firstIR_in = branch ? nop : q_imem;

    register firstIR(clock, ~stall & ~hazard, firstIR_in, reset, firstIR_out);
    register firstPC(clock, ~stall & ~hazard, pcAddResult, reset, firstPC_out);

    /****** Decode stage ******/

    assign sReg = firstIR_out[31:27]==bex ? 5'b11110 : firstIR_out[21:17];
	assign tReg = firstIR_out[16:12];
    assign dReg = firstIR_out[31:27]==bex ? 5'b0 : firstIR_out[26:22];
    assign ctrl_readRegA = !(|firstIR_out[31:27]) || firstIR_out[31:27]==sw || firstIR_out[31:27]==lw || firstIR_out[31:27]==bne || firstIR_out[31:27]==blt || firstIR_out[31:27]==addi || firstIR_out[31:27]==bex || firstIR_out[31:27]==sur || firstIR_out[31:27]==sul || firstIR_out[31:27]==sura || firstIR_out[31:27]==sula ? sReg : 5'b0; // for if it is an r type or an i type
    assign ctrl_readRegB = !(|firstIR_out[31:27]) || firstIR_out[31:27]==sura || firstIR_out[31:27]==sula ? tReg : dReg; // if it is an r type

    assign secondIR_in = branch || hazard ? nop : firstIR_out;

    register secondIR(clock, ~stall, secondIR_in, reset, secondIR_out);
    register secondPC(clock, ~stall, firstPC_out, reset, secondPC_out);
    register fileRead1(clock, ~stall, data_readRegA, reset, data1_out);
    register fileRead2(clock, ~stall, data_readRegB, reset, data2_out);

    /****** Execute stage ******/
    assign branch_op = secondIR_out[31:27]==bne || secondIR_out[31:27]==blt || secondIR_out[31:27]==bex ? 5'b00001 : 5'b0;
    assign aluOP = !(|secondIR_out[31:27]) ? secondIR_out[6:2] : branch_op;
    // needs to be changed to account for the fact that the jump target is of different size than the I instruction immediate
    assign sxImmediate = secondIR_out[31:27]==jal || secondIR_out[31:27]==j || secondIR_out[31:27]==setx ||  secondIR_out[31:27]==bex ? {{5{secondIR_out[26]}}, secondIR_out[26:0]} : {{15{secondIR_out[16]}}, secondIR_out[16:0]}; 
    //assign aluIn2_decision = () ? (data_writeReg) : (() ? () : ()) //try ternary within a ternary

    assign sReg_two = secondIR_out[31:27]==bex ? 5'b11110 : secondIR_out[21:17];  
    assign tReg_two = secondIR_out[16:12];
    assign dReg_two = secondIR_out[31:27]==bex ? 5'b0 : secondIR_out[26:22];
    assign prev_RegA = !(|secondIR_out[31:27]) || secondIR_out[31:27]==sw || secondIR_out[31:27]==lw || secondIR_out[31:27]==bne || secondIR_out[31:27]==blt || secondIR_out[31:27]==addi || secondIR_out[31:27]==bex || secondIR_out[31:27]==sur || secondIR_out[31:27]==sul || secondIR_out[31:27]==sura || secondIR_out[31:27]==sula ? sReg_two : 5'b0; // for if it is an r type or an i type
    assign prev_RegB = !(|secondIR_out[31:27]) || secondIR_out[31:27]==sura || secondIR_out[31:27]==sula ? tReg_two : dReg_two;

    // assign aluIn2_decision = (prev_RegB==fourthIR_out[26:22] && fourthIR_out[26:22]!=5'b0 && fourthIR_out[31:27]!=sw) ? (data_writeReg) : ((prev_RegB==thirdIR_out[26:22] && thirdIR_out[26:22]!=5'b0 && thirdIR_out[31:27]!=sw) ? (aluReg_out) : (data2_out)); //try ternary within a ternary
    assign aluIn2_decision = ((prev_RegB==thirdIR_out[26:22] || (prev_RegB==5'b11110 && ovflow_det1)) && thirdIR_out[26:22]!=5'b0 && thirdIR_out[31:27]!=sw && thirdIR_out[31:27]!=blt && thirdIR_out[31:27]!=bne) ? (aluReg_out) : (((prev_RegB==fourthIR_out[26:22] || (prev_RegB==5'b11110 && ovflow_det2)) && fourthIR_out[26:22]!=5'b0 && fourthIR_out[31:27]!=sw && fourthIR_out[31:27]!=blt && fourthIR_out[31:27]!=bne) ? (data_writeReg) : (data2_out)); //try ternary within a ternary
    // assign mainALU_in1 = (prev_RegA==fourthIR_out[26:22] && fourthIR_out!=5'b0 && fourthIR_out[31:27]!=sw) ? (data_writeReg) : ((prev_RegA==thirdIR_out[26:22] && thirdIR_out[26:22]!=5'b0 && thirdIR_out[31:27]!=sw) ? (aluReg_out) : (data1_out)); //try ternary within a ternary
    assign mainALU_in1 = ((prev_RegA==thirdIR_out[26:22] || ((prev_RegA==5'b11110 || secondIR_out[31:27]==bex) && ovflow_det1)) && (thirdIR_out[26:22]!=5'b0 || thirdIR_out[31:27]==setx) && thirdIR_out[31:27]!=sw && thirdIR_out[31:27]!=blt && thirdIR_out[31:27]!=bne) ? (aluReg_out) : (((prev_RegA==fourthIR_out[26:22] || ((prev_RegA==5'b11110 || secondIR_out[31:27]==bex) && ovflow_det2)) && fourthIR_out!=5'b0 && fourthIR_out[31:27]!=sw && fourthIR_out[31:27]!=bne && fourthIR_out[31:27]!=blt) ? (data_writeReg) : (data1_out)); //try ternary within a ternary
    assign mainALU_in2 = secondIR_out[31:27]==addi || secondIR_out[31:27]==lw || secondIR_out[31:27]==sw ? sxImmediate : aluIn2_decision;

    alu mainALU(mainALU_in1, mainALU_in2, aluOP, secondIR_out[11:7], mainALU_res, noteq, lessthan, ovflow);
    alu pcUpdate(secondPC_out, sxImmediate, 5'b00000, 5'b00000, updated_pc, useless, useless, useless);
    alu jalSpecific(secondPC_out, {31'b0, 1'b0}, 5'b00000, 5'b00000, pc_plus, useless, useless, useless);

    assign jumpType_pc = secondIR_out[31:27]==jal || secondIR_out[31:27]==j || secondIR_out[31:27]==bex ? sxImmediate : aluIn2_decision;
    assign temp = secondIR_out[31:27]==blt || secondIR_out[31:27]==bne ? updated_pc : jumpType_pc;

    assign branch = (secondIR_out[31:27]==bex && noteq) || (secondIR_out[31:27]==blt && (!lessthan && noteq)) || (secondIR_out[31:27]==bne && noteq) || secondIR_out[31:27]==jal || secondIR_out[31:27]==j || secondIR_out[31:27]==jr ? 1'b1 : 1'b0;
    //assign branch = (secondIR_out[31:27]==blt && (!lessthan && noteq)) || (secondIR_out[31:27]==bne && noteq) ? 1'b1 : 1'b0;
    assign isMult = !(|secondIR_out[31:27]) && (aluOP==5'b00110);
    assign isDiv = !(|secondIR_out[31:27]) && (aluOP==5'b00111);

    multdiv mainMult(mainALU_in1, aluIn2_decision, ctrl_mult, ctrl_div, ~clock, multDivRes, data_exp, data_rdy);

    // Handle shift up
    wire is_anded_su = secondIR_out[30]; // Check if it's sula or sura
    wire su_direction = secondIR_out[27];
    wire is_su = secondIR_out[31] && !secondIR_out[29] && !secondIR_out[28];

    wire [31:0] sur_result, sul_result, sura_result, sula_result, fin_su_result;
    sur test_sur(sur_result, is_anded_su ? mainALU_in2 : mainALU_in1);
    sul test_sul(sul_result, is_anded_su ? mainALU_in2 : mainALU_in1);
    wire [31:0] fin_su_simple_result = su_direction ? sur_result : sul_result;
    
    assign sura_result = mainALU_in1 & sur_result;
    assign sula_result = mainALU_in1 & sul_result;
    wire [31:0] fin_sua_result = su_direction ? sura_result : sula_result;

    assign fin_su_result = is_anded_su ? fin_sua_result : fin_su_simple_result;
    assign true_result = is_su ? fin_su_result : ((isDiv || isMult) ? multDivRes : mainALU_res);

    dffe_ref stallMult(stall_mult, isMult, clock, 1'b1, data_rdy);
    dffe_ref cntrlMult(ctrl_mult_temp, isMult, clock, 1'b1, reset);
    dffe_ref stallDiv(stall_div, isDiv, clock, 1'b1, data_rdy);
    dffe_ref cntrlDiv(ctrl_div_temp, isDiv & ~data_rdy, clock, 1'b1, reset);

    assign ctrl_mult = !(ctrl_mult_temp) && isMult;
    assign ctrl_div = !(ctrl_div_temp) && isDiv;
    assign stall = stall_mult || stall_div || ctrl_mult || ctrl_div;

    assign ovflow_add = ovflow && !(|secondIR_out[31:27]) && aluOP==5'b0 && secondIR_out[26:22]!=5'b0;
    assign ovflow_sub = ovflow && !(|secondIR_out[31:27]) && aluOP=={4'b0, 1'b1} && secondIR_out[26:22]!=5'b0; 
    assign ovflow_addi = ovflow && secondIR_out[31:27]==addi && secondIR_out[26:22]!=5'b0;
    assign ovflow_mul = data_exp && isMult;
    assign ovflow_div = data_exp && isDiv;

    assign alu_res_withovflow = ovflow_add ? {31'b0, 1'b1} : 32'bz;
    assign alu_res_withovflow = ovflow_sub ? {30'b0, 1'b1, 1'b1} : 32'bz;
    assign alu_res_withovflow = ovflow_addi ? {30'b0, 1'b1, 1'b0}: 32'bz;
    assign alu_res_withovflow = secondIR_out[31:27] == setx ? sxImmediate : 32'bz;

    assign alu_res_withovflow = ovflow_mul ? {29'b0, 1'b1, 2'b0} : 32'bz;
    assign alu_res_withovflow = ovflow_div ? {29'b0, 3'b101} : 32'bz;

    assign alu_res_withovflow = !(ovflow_add || ovflow_addi || ovflow_sub || ovflow_mul || ovflow_div || secondIR_out[31:27] == setx) ? true_result : 32'bz;

    assign aluReg_in = secondIR_out[31:27]==jal ? pc_plus : alu_res_withovflow;

    register thirdIR(clock, ~stall, secondIR_out, reset, thirdIR_out);
    register aluOut(clock, ~stall, aluReg_in, reset, aluReg_out);
    register secondInput(clock, ~stall, aluIn2_decision, reset, secondIn_out);
    dffe_ref firstOvflowDetect(
        ovflow_det1,
        (ovflow_add || ovflow_addi || ovflow_sub || ovflow_mul || ovflow_div || (secondIR_out[31:27] == setx)),
        clock,
        ~stall,
        reset
    );

    /****** Memory stage ******/

    assign wren = thirdIR_out[31:27]==sw ? 1'b1 : 1'b0;
    assign address_dmem = aluReg_out;
    assign data_condition = (!(|fourthIR_out[31:27]) || fourthIR_out[31:27]==addi || fourthIR_out[31:27]==sur || fourthIR_out[31:27]==sul || fourthIR_out[31:27]==sura || fourthIR_out[31:27]==sula || fourthIR_out[31:27]==lw || fourthIR_out[31:27]==jal) && (fourthIR_out[26:22]==thirdIR_out[26:22]) && thirdIR_out[31:27]==sw;// We only bypass at this stage if the instruction at this stage is sw and the next stage is rd manipulating
    assign data = data_condition ? data_writeReg : secondIn_out;

    // change the alu to include offset for the lw and sw instructions
    // also change the alu to account for that fact that rd is used for the comparisons for bne and blt and for jr
    register fourthIR(clock, ~stall, thirdIR_out, reset, fourthIR_out);
    register aluOut2(clock, ~stall, aluReg_out, reset, aluReg2_out);
    register dmemOut(clock, ~stall, q_dmem, reset, dmemReg_out);
    dffe_ref secondOvflowDetect(ovflow_det2, ovflow_det1, clock, ~stall, reset);
    /****** Writeback stage ******/

    assign data_writeReg = !(|fourthIR_out[31:27]) || fourthIR_out[31:27]==addi || fourthIR_out[31:27]==sur || fourthIR_out[31:27]==sul || fourthIR_out[31:27]==sula || fourthIR_out[31:27]==sura || fourthIR_out[31:27]==jal || fourthIR_out[31:27]==setx ? aluReg2_out : dmemReg_out;
    assign ctrl_writeEnable = (!(|fourthIR_out[31:27]) || fourthIR_out[31:27]==lw || fourthIR_out[31:27]==addi || fourthIR_out[31:27]==jal || fourthIR_out[31:27]==setx) ? 1'b1 : 1'b0;
    //assign ctrl_writeReg = fourthIR_out[31:27]==jal ? 5'b11111 : fourthIR_out[26:22];
    assign ctrl_writeReg = fourthIR_out[31:27]==jal ? 5'b11111 : 32'bz;
    assign ctrl_writeReg = ovflow_det2 ? 5'b11110 : 32'bz;
    assign ctrl_writeReg = !(ovflow_det2) && fourthIR_out[31:27]!=jal ? fourthIR_out[26:22] : 32'bz;

    // assign ctrl_writeReg = fourthIR_out[31:27]!=lw ? fourthIR_out[26:22] : fourthIR_out[26:22]-1;

	/* END CODE */

endmodule