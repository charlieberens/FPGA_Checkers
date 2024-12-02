module ovflow(overflow, add_result, data_operandA, b);
    input [31:0] add_result, data_operandA, b;
    output overflow;

    wire b_sign, a_sign, ov_s1, ov_s2, res_sign;

    not resign(res_sign, add_result[31]);
    not bsign(b_sign, b[31]);
    not asign(a_sign, data_operandA[31]);
    and ovstep1(ov_s1, a_sign, b_sign, add_result[31]);
    and ovstep2(ov_s2, data_operandA[31], b[31], res_sign);
    or ovfinal(overflow, ov_s1, ov_s2);
endmodule