// This takes a 32 bit board state and shifts it up down to the right by 1. Setting the borders to 1.
// The board is 0 indexed starting from the top left, moving right first.
module sdl(
    output[31:0] A_shifted,
    input[31:0] A
);
// Set the top border
assign A_shifted[3:0] = 4'b0;
// Set right
assign A_shifted[7] = 1'b0;
assign A_shifted[15] = 1'b0;
assign A_shifted[23] = 1'b0;
assign A_shifted[31] = 1'b0;

// Set the rest
assign A_shifted[6:4] = A[3:1];
assign A_shifted[11:8] = A[7:4];

assign A_shifted[14:12] = A[11:9];
assign A_shifted[19:16] = A[15:12];

assign A_shifted[22:20] = A[19:17];
assign A_shifted[27:24] = A[20:13];

assign A_shifted[30:28] = A[27:25];
endmodule