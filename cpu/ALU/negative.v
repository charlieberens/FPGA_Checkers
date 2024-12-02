module negative(res, in);
    input [31:0] in;
    output [31:0] res;

    not first(res[0], in[0]);
    not second(res[1], in[1]);
    not third(res[2], in[2]);
    not fourth(res[3], in[3]);
    not fifth(res[4], in[4]);
    not sixth(res[5], in[5]);
    not seventh(res[6], in[6]);
    not eighth(res[7], in[7]);
    not ninth(res[8], in[8]);
    not tenth(res[9], in[9]);
    not eleventh(res[10], in[10]);
    not twelfth(res[11], in[11]);
    not thirteenth(res[12], in[12]);
    not fourteenth(res[13], in[13]);
    not fifteenth(res[14], in[14]);
    not sixteenth(res[15], in[15]);
    not seventeenth(res[16], in[16]);
    not eighteenth(res[17], in[17]);
    not nineteenth(res[18], in[18]);
    not twentieth(res[19], in[19]);
    not twentyfirst(res[20], in[20]);
    not twentysecond(res[21], in[21]);
    not twentythird(res[22], in[22]);
    not twentyfourth(res[23], in[23]);
    not twentyfifth(res[24], in[24]);
    not twentysixth(res[25], in[25]);
    not twentyseventh(res[26], in[26]);
    not twentyeighth(res[27], in[27]);
    not twentyninth(res[28], in[28]);
    not thirtieth(res[29], in[29]);
    not thirtyfirst(res[30], in[30]);
    not thirtysecond(res[31], in[31]);

endmodule