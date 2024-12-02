module isless(isLessThan, Cin, add_result, overflow);
    output isLessThan;
    input Cin, overflow;
    input [31:0] add_result;
    wire ls_s1, ls_s2, n_add, n_ov;

    not nadd(n_add, add_result[31]);
    not nov(n_ov, overflow);
    and ls1(ls_s1, Cin, add_result[31], n_ov);
    and ls2(ls_s2, Cin, n_add, overflow);
    or ls(isLessThan, ls_s1, ls_s2);
endmodule