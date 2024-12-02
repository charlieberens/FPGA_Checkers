// This takes a 32 bit board state and shifts it up and to the right by 1. Setting the borders to 1.
// The board is 0 indexed starting from the top left, moving right first.
module sur(
    output[31:0] A_shifted,
    input[31:0] A
);
// Set the left border
assign A_shifted[0] = 1'b1;
assign A_shifted[4] = 1'b1;
assign A_shifted[8] = 1'b1;
assign A_shifted[12] = 1'b1;
assign A_shifted[16] = 1'b1;
assign A_shifted[20] = 1'b1;
assign A_shifted[24] = 1'b1;

// Set the bottom border
assign A_shifted[28:31] = 4'b1111;

// Set the rest
assign A_shifted[1:3] = A[4:6];
assign A_shifted[5:7] = A[8:10];
assign A_shifted[9:11] = A[12:14];
assign A_shifted[13:15] = A[16:18];
assign A_shifted[17:19] = A[20:22];
assign A_shifted[21:23] = A[24:26];
assign A_shifted[25:27] = A[28:30];
endmodule