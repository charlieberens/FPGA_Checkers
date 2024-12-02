module sra_2(result, A);
    input [31:0] A;
    output [31:0] result;
    assign result = {A[31], A[31], A[31:2]};
endmodule