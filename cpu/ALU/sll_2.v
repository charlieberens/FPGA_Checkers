module sll_2(result, A);
    input [31:0] A;
    output [31:0] result;
    assign result = {A[29:0], 2'b00};
endmodule