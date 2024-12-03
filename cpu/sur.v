// This takes a 32 bit board state and shifts it up and to the right by 1. Setting the borders to 1.
// The board is 0 indexed starting from the top left, moving right first.
module sur(
    output[31:0] A_shifted,
    input[31:0] A
);
// Set the left border
assign A_shifted[4] = 1'b1;
assign A_shifted[12] = 1'b1;
assign A_shifted[20] = 1'b1;

// Set the bottom border
assign A_shifted[31:28] = 4'b1111;

// Set the rest
assign A_shifted[3:0] = A[7:4];
assign A_shifted[7:5] = A[10:8];

assign A_shifted[11:8] = A[15:12];
assign A_shifted[15:13] = A[18:16];

assign A_shifted[19:16] = A[23:20];
assign A_shifted[23:21] = A[26:24];

assign A_shifted[27:24] = A[31:28];
endmodule