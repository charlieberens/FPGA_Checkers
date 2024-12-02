module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // add your code here

    wire [31:0] div_res, mul_res;
    wire mult_exp, div_exp, mult_rdy, div_rdy, t_bit, t_out;
    multi multiply(clock, data_operandA, data_operandB, ctrl_MULT, mult_rdy, mult_exp, mul_res);
    divi divide(clock, data_operandA, data_operandB, ctrl_DIV, div_rdy, div_exp, div_res);

    assign t_bit = ~t_out ? ctrl_DIV : ctrl_MULT;
    tff t_flipper(t_bit, clock, 1'b0, t_out);

    assign data_exception = t_out ? div_exp : mult_exp;
    assign data_resultRDY = t_out ? div_rdy : mult_rdy;
    assign data_result = t_out ? div_res : mul_res;


endmodule