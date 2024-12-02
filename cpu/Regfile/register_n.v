module register_n #(parameter WIDTH = 32)(clk, in_en, data_in, clr, data_out);
    input clk, in_en, clr;
    input [WIDTH-1:0] data_in;
    output [WIDTH-1:0] data_out;

    genvar i;
    generate
        for(i=0; i<WIDTH; i=i+1)begin
            dffe_ref flip_flop(data_out[i], data_in[i], clk, in_en, clr);
        end
    endgenerate
endmodule