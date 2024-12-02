module noteq(isNotEqual, add_result, Cin);
    input [31:0] add_result;
    input Cin;
    output isNotEqual;
    wire s1, s2, s3, s4, s5;

    or step1(s1, add_result[0], add_result[1], add_result[2], add_result[3], add_result[4], add_result[5], add_result[6], add_result[7]);
    or step2(s2, add_result[8], add_result[9], add_result[10], add_result[11], add_result[12], add_result[13], add_result[14], add_result[15]);
    or step3(s3, add_result[16], add_result[17], add_result[18], add_result[19], add_result[20], add_result[21], add_result[22], add_result[23]);
    or step4(s4, add_result[24], add_result[25], add_result[26], add_result[27], add_result[28], add_result[29], add_result[30], add_result[31]);
    or step5(s5, s1, s2, s3, s4);
    and final(isNotEqual, s5, Cin);
endmodule