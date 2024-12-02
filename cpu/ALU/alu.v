module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    wire [31:0] b, b_neg, add_result, and_result, or_result, sll_result, sra_result;
    wire Cout_add, Cin1, Cin2, Cin, ov_s1, ov_s2, res_sign, b_sign, a_sign;
    wire [2:0] select;

    not cinone(Cin1, ctrl_ALUopcode[2]);
    not cintwo(Cin2, ctrl_ALUopcode[1]);
    and cin(Cin, Cin1, Cin2, ctrl_ALUopcode[0]);
    negative test_neg(b_neg, data_operandB);

    assign select = {ctrl_ALUopcode[2], ctrl_ALUopcode[1], ctrl_ALUopcode[0]};
    assign b = Cin ? b_neg : data_operandB;

    ovflow ov(overflow, add_result, data_operandA, b);
    isless ls(isLessThan, Cin, add_result, overflow);
    noteq ne(isNotEqual, add_result, Cin);

    two_level_cla test_add(add_result, Cout_add, data_operandA, b, Cin);
    bitwise_and test_and(and_result, data_operandA, data_operandB);
    bitwise_or test_or(or_result, data_operandA, data_operandB);
    sl_logical test_sll(sll_result, data_operandA, ctrl_shiftamt);
    sr_arithmetic test_sra(sra_result, data_operandA, ctrl_shiftamt);

    mux_8 res(
        data_result,
        select,
        add_result,
        add_result,
        and_result,
        or_result,
        sll_result,
        sra_result,
        sra_result, // 01 110 (sur) and 11 110 (sura)
        sra_result  // 01 111 (sul) and 11 111 (sula)
    );

endmodule