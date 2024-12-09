// This takes a 32 bit board state and shifts it up down to the left by 1. Setting the borders to 0.
// The board is 0 indexed starting from the top left, moving right first.
module sdr(
    output[31:0] A_shifted,
    input[31:0] A
);
// Set the top border
assign A_shifted[3:0] = 4'b0;
// Set left border
assign A_shifted[8] = 1'b0;
assign A_shifted[16] = 1'b0;
assign A_shifted[24] = 1'b0;
assign A_shifted[31] = 1'b0;

// Set the rest
assign A_shifted[7:4] = A[3:0];
assign A_shifted[11:9] = A[6:4];

assign A_shifted[15:12] = A[11:8];
assign A_shifted[19:17] = A[14:12];

assign A_shifted[23:20] = A[19:16];
assign A_shifted[27:25] = A[22:20];

assign A_shifted[31:28] = A[27:24];
endmodule