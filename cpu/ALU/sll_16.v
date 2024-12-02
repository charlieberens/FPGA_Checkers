module sll_16(result, A);
    input [31:0] A;
    output [31:0] result;
    assign result = {A[15:0], 16'b0000000000000000};
endmodule