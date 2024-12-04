// This takes a 32 bit board state and shifts it up and to the left by 1. Setting the borders to 1.
// The board is 0 indexed starting from the top left, moving right first.
module sul(
    output[31:0] A_shifted,
    input[31:0] A
);
// Set the right border
assign A_shifted[7] = 1'b1;
assign A_shifted[7] = 1'b1;
assign A_shifted[15] = 1'b1;
assign A_shifted[23] = 1'b1;

// Set the bottom border
assign A_shifted[31:28] = 4'b1111;

// Set the rest
assign A_shifted[3:0] = A[7:4];
assign A_shifted[6:4] = A[11:9];

assign A_shifted[11:8] = A[15:12];
assign A_shifted[14:12] = A[19:17];

assign A_shifted[19:16] = A[23:20];
assign A_shifted[22:20] = A[27:25];

assign A_shifted[27:24] = A[31:28];
endmodule