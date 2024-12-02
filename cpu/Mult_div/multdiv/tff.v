module tff(toggle, clk, clr, q);
    input toggle, clk, clr;
    output q;
    wire w1, w2, w3, n_t, n_q;

    dffe_ref dflip(q, w3, clk, 1'b1, clr);
    not neg_t(n_t, toggle);
    not neg_q(n_q, q);

    and top_and(w1, n_t, q);
    and bottom_and(w2, n_q, toggle);
    or main_or(w3, w1, w2);

endmodule