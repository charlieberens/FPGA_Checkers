module sra_16(result, A);
    input [31:0] A;
    output [31:0] result;
    assign result = {A[31], A[31], A[31], A[31], A[31], A[31], A[31], A[31], A[31], A[31], A[31], A[31], A[31], A[31], A[31], A[31], A[31:16]};
endmodule