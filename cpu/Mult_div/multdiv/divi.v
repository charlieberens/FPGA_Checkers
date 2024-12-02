module divi(clk, dividend, divisor, ctrl_div, rdy, exp, result);
    input [31:0] dividend, divisor;
    input ctrl_div, clk;
    output rdy, exp;
    output [31:0] result;

    wire useless, useless1, useless2, overflow, control1, control2, sign;
    wire [63:0] reg_in, reg_out, in_mux1;
    wire [31:0] alu_out, real_divisor, real_dividend, temp_divid, temp_divis, neg_res, abs_result;
    wire [5:0] count_res;

    alu neg_divid(~dividend, {31'b0, 1'b1}, 5'b0, 5'b0, temp_divid, useless, useless, useless);
    alu neg_divis(~divisor, {31'b0, 1'b1}, 5'b0, 5'b0, temp_divis, useless, useless, useless);
    alu neg_resu(~reg_out[31:0], {31'b0, 1'b1}, 5'b0, 5'b0, neg_res, useless, useless, useless);

    assign real_divisor = divisor[31] ? temp_divis : divisor;
    assign real_dividend = dividend[31] ? temp_divid : dividend;

    assign control1 = reg_out[63];
    assign control2 = alu_out[31];
    alu w1({reg_out[62:31]}, real_divisor, {4'b0, !control1}, 5'b0, alu_out, useless1, useless2, overflow);

    assign in_mux1 = {alu_out[31:0], reg_out[30:0], !control2};
    assign reg_in = ctrl_div ? {32'b0, real_dividend} : in_mux1;
    
    register_n #(64) rq(clk, 1'b1, reg_in, ctrl_div & (|{count_res[5], count_res[4], count_res[3], count_res[2], count_res[1]}), reg_out);

    counter div_count(clk, 1'b1, (count_res[5]&count_res[1]) | (ctrl_div & (|{count_res[5], count_res[4], count_res[3], count_res[2], count_res[1]})), count_res);
    assign sign = dividend[31] ^ divisor[31];
    assign rdy = count_res[5]&count_res[0];
    assign exp = !(|divisor);
    assign abs_result = sign ? neg_res : reg_out[31:0];
    assign result = exp ? 32'b0 : abs_result;

endmodule