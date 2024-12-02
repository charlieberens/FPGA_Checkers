module sll_8(result, A);
    input [31:0] A;
    output [31:0] result;
    assign result = {A[23:0], 8'b00000000};
endmodule