module register (clk, in_en, data_in, clr, data_out);
    input clk, in_en, clr;
    input [31:0] data_in;
    output [31:0] data_out;

    genvar i;
    generate
        for(i=0; i<32; i=i+1)begin
            dffe_ref flip_flop(data_out[i], data_in[i], clk, in_en, clr);
        end
    endgenerate
endmodule