// This takes a 32 bit board state and shifts it up and to the left by 1. Setting the borders to 1.
// The board is 0 indexed starting from the top left, moving right first.
module sul(
    output[31:0] A_shifted,
    input[31:0] A
);
// Set the right border
assign A_shifted[3] = 1'b1;
assign A_shifted[11] = 1'b1;
assign A_shifted[19] = 1'b1;
assign A_shifted[27] = 1'b1;

// Set the bottom border
assign A_shifted[31:28] = 4'b1111;

// Set the rest
assign A_shifted[2:0] = A[8:5];
assign A_shifted[7:4] = A[11:8];

assign A_shifted[10:8] = A[16:13];
assign A_shifted[15:12] = A[19:16];

assign A_shifted[18:16] = A[24:21];
assign A_shifted[23:20] = A[27:24];

assign A_shifted[26:24] = A[32:29];
endmodule