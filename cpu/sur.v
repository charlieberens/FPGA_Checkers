// This takes a 32 bit board state and shifts it up and to the right by 1. Setting the borders to 1.
// The board is 0 indexed starting from the top left, moving right first.
module sur(
    output[31:0] A_shifted,
    input[31:0] A
);
// Set the left border
assign A_shifted[0] = 1'b1;
assign A_shifted[8] = 1'b1;
assign A_shifted[16] = 1'b1;
assign A_shifted[24] = 1'b1;

// Set the bottom border
assign A_shifted[31:28] = 4'b1111;

// Set the rest
assign A_shifted[3:1] = A[6:4];
assign A_shifted[7:4] = A[11:8];

assign A_shifted[11:9] = A[14:12];
assign A_shifted[15:12] = A[19:16];

assign A_shifted[19:17] = A[22:20];
assign A_shifted[23:20] = A[27:24];

assign A_shifted[27:25] = A[30:28];
endmodule