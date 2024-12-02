module sll_1(result, A);
    input [31:0] A;
    output [31:0] result;
    assign result = {A[30:0], 1'b0};
endmodule