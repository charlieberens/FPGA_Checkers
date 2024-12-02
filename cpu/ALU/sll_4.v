module sll_4(result, A);
    input [31:0] A;
    output [31:0] result;
    assign result = {A[27:0], 4'b0000};
endmodule