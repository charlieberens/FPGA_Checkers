// This takes a 32 bit board state and shifts it up and to the left by 1. Setting the borders to 1.
// The board is 0 indexed starting from the top left, moving right first.
module sur(
    output[31:0] A_shifted,
    input[31:0] A
);
// Set the right border
assign A_shifted[3] = 1'b1;
assign A_shifted[7] = 1'b1;
assign A_shifted[11] = 1'b1;
assign A_shifted[15] = 1'b1;
assign A_shifted[19] = 1'b1;
assign A_shifted[23] = 1'b1;
assign A_shifted[27] = 1'b1;
assign A_shifted[31] = 1'b1;

// Set the bottom border
assign A_shifted[28:31] = 4'b1111;

// Set the rest
assign A_shifted[0:2] = A[4:6];
assign A_shifted[4:6] = A[8:10];
assign A_shifted[8:10] = A[12:14];
assign A_shifted[12:14] = A[16:18];
assign A_shifted[16:18] = A[20:22];
assign A_shifted[20:22] = A[24:26];
assign A_shifted[24:26] = A[28:30];
endmodule