module counter(clk, count, clr, result);
    input clk, count, clr;
    output[5:0] result;
    wire and_out1, and_out2, and_out3, and_out4, and_out5, w1, w2, w3, w4;

    tff t_flip1(count, clk, clr, result[0]);
    and and1(and_out1, count, result[0]);

    tff t_flip2(and_out1, clk, clr, result[1]);
    and and2(and_out2, and_out1, result[1]);

    tff t_flip3(and_out2, clk, clr, result[2]);
    and and3(and_out3, and_out2, result[2]);

    tff t_flip4(and_out3, clk, clr, result[3]);
    and and4(and_out4, and_out3, result[3]);

    tff t_flip5(and_out4, clk, clr, result[4]);
    and and5(and_out5, and_out4, result[4]);

    tff t_flip6(and_out5, clk, clr, result[5]);

    //assign result[4] = 1'b0;

endmodule