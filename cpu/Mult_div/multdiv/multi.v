module multi(clk, data_A, data_B, ctrl_mult, rdy, exp, result);
    input [31:0] data_A, data_B;
    input ctrl_mult, clk;
    output [31:0] result;
    output rdy, exp;
    wire [31:0] in1_mux, out1_mux, reg1_out, alu_out;
    wire [2:0] control_out;
    wire [65:0] in2_mux1, in2_mux2, reg2_out;
    wire [5:0] count_res;
    wire useless1, useless2, overflow, en, ex_bit;

    assign in1_mux = ctrl_mult ? data_A : reg1_out;
    register_n #(32) multiplicand(clk, 1'b1, in1_mux, 1'b0, reg1_out);
    assign out1_mux = control_out[2] ? reg1_out<<1 : reg1_out;

    assign ex_bit = overflow ? !alu_out[31] : alu_out[31];

    assign in2_mux1 = control_out[0] ? {ex_bit, ex_bit, ex_bit, alu_out[31:0], reg2_out[32:2]} : {reg2_out[65], reg2_out[65], reg2_out[65:2]};
    assign in2_mux2 = ctrl_mult ? {1'b0, 32'b0, data_B, 1'b0} : in2_mux1;
    register_n #(66) multiplier(clk, 1'b1, in2_mux2, ctrl_mult & (|{count_res[4], count_res[3], count_res[2], count_res[1]}), reg2_out);

    assign control_out[2] = (!reg2_out[2] & reg2_out[1] & reg2_out[0]) | (reg2_out[2] & !reg2_out[1] & !reg2_out[0]);
    assign control_out[1] = (reg2_out[2] & !reg2_out[1]) | (reg2_out[2] & !reg2_out[0]);
    assign control_out[0] = (reg2_out[2] & !reg2_out[1]) | (reg2_out[1] & !reg2_out[0]) | (!reg2_out[2] & reg2_out[0]);

    alu w1(reg2_out[64:33], out1_mux, {4'b0, control_out[1]}, 5'b0, alu_out, useless1, useless2, overflow);

    counter mult_count(clk, 1'b1, (count_res[4]&count_res[1]) | (ctrl_mult & (|{count_res[4], count_res[3], count_res[2], count_res[1]})), count_res);
    
    assign rdy = count_res[4]&count_res[0];
    assign result = reg2_out[32:1];
    
    assign exp = rdy ? !(!(|reg2_out[65:32]) ^ &reg2_out[65:32]) : 1'b0;


endmodule