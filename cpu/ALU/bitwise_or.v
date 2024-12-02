module bitwise_or(result, A, B);
    input [31:0] A, B;
    output [31:0] result;

    or first(result[0], A[0], B[0]);
    or second(result[1], A[1], B[1]);
    or third(result[2], A[2], B[2]);
    or fourth(result[3], A[3], B[3]);
    or fifth(result[4], A[4], B[4]);
    or sixth(result[5], A[5], B[5]);
    or seventh(result[6], A[6], B[6]);
    or eighth(result[7], A[7], B[7]);
    or ninth(result[8], A[8], B[8]);
    or tenth(result[9], A[9], B[9]);
    or eleventh(result[10], A[10], B[10]);
    or twelfth(result[11], A[11], B[11]);
    or thirteenth(result[12], A[12], B[12]);
    or fourteenth(result[13], A[13], B[13]);
    or fifteenth(result[14], A[14], B[14]);
    or sixteenth(result[15], A[15], B[15]);
    or seventeenth(result[16], A[16], B[16]);
    or eighteenth(result[17], A[17], B[17]);
    or nineteenth(result[18], A[18], B[18]);
    or twentieth(result[19], A[19], B[19]);
    or twentyfirst(result[20], A[20], B[20]);
    or twentysecond(result[21], A[21], B[21]);
    or twentythird(result[22], A[22], B[22]);
    or twentyfourth(result[23], A[23], B[23]);
    or twentyfifth(result[24], A[24], B[24]);
    or twentysixth(result[25], A[25], B[25]);
    or twentyseventh(result[26], A[26], B[26]);
    or twentyeighth(result[27], A[27], B[27]);
    or twentyninth(result[28], A[28], B[28]);
    or thirtieth(result[29], A[29], B[29]);
    or thirtyfirst(result[30], A[30], B[30]);
    or thirtysecond(result[31], A[31], B[31]);

endmodule