module bitwise_and(result, A, B);
    input [31:0] A, B;
    output [31:0] result;

    and first(result[0], A[0], B[0]);
    and second(result[1], A[1], B[1]);
    and third(result[2], A[2], B[2]);
    and fourth(result[3], A[3], B[3]);
    and fifth(result[4], A[4], B[4]);
    and sixth(result[5], A[5], B[5]);
    and seventh(result[6], A[6], B[6]);
    and eighth(result[7], A[7], B[7]);
    and ninth(result[8], A[8], B[8]);
    and tenth(result[9], A[9], B[9]);
    and eleventh(result[10], A[10], B[10]);
    and twelfth(result[11], A[11], B[11]);
    and thirteenth(result[12], A[12], B[12]);
    and fourteenth(result[13], A[13], B[13]);
    and fifteenth(result[14], A[14], B[14]);
    and sixteenth(result[15], A[15], B[15]);
    and seventeenth(result[16], A[16], B[16]);
    and eighteenth(result[17], A[17], B[17]);
    and nineteenth(result[18], A[18], B[18]);
    and twentieth(result[19], A[19], B[19]);
    and twentyfirst(result[20], A[20], B[20]);
    and twentysecond(result[21], A[21], B[21]);
    and twentythird(result[22], A[22], B[22]);
    and twentyfourth(result[23], A[23], B[23]);
    and twentyfifth(result[24], A[24], B[24]);
    and twentysixth(result[25], A[25], B[25]);
    and twentyseventh(result[26], A[26], B[26]);
    and twentyeighth(result[27], A[27], B[27]);
    and twentyninth(result[28], A[28], B[28]);
    and thirtieth(result[29], A[29], B[29]);
    and thirtyfirst(result[30], A[30], B[30]);
    and thirtysecond(result[31], A[31], B[31]);

endmodule