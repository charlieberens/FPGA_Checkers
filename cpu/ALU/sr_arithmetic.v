module sr_arithmetic(result, A, amount);
    input [4:0] amount;
    input [31:0] A;
    output [31:0] result;
    wire [31:0] w1, w1m, w2, w2m, w3, w3m, w4, w4m, w5;

    sra_16 s_teen(w1, A);
    mux_2 sixteen(w1m, amount[4], A, w1);

    sra_8 ate(w2, w1m);
    mux_2 eight(w2m, amount[3], w1m, w2);

    sra_4 fore(w3, w2m);
    mux_2 four(w3m, amount[2], w2m, w3);

    sra_2 too(w4, w3m);
    mux_2 two(w4m, amount[1], w3m, w4);

    sra_1 un(w5, w4m);
    mux_2 one(result, amount[0], w4m, w5);

endmodule