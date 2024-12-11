module transform(
    input [31:0] in,
    output [31:0] out
);
// assign out[7:4] = {in[4], in[5], in[6], in[7]};
// assign out[15:12] = {in[12], in[13], in[14], in[15]};
// assign out[23:20] = {in[20], in[21], in[22], in[23]};
// assign out[31:28] = {in[28], in[29], in[30], in[31]};

// assign out[3:0] = in[3:0];
// assign out[11:8] = in[11:8];
// assign out[19:16] = in[19:16];
// assign out[27:24] = in[27:24];

assign out[7:4] = in[7:4];
assign out[15:12] = in[15:12];
assign out[23:20] = in[23:20];
assign out[31:28] = in[31:28];

assign out[3:0] = {in[0], in[1], in[2], in[3]};
assign out[11:8] = {in[8], in[9], in[10], in[11]};
assign out[19:16] = {in[16], in[17], in[18], in[19]};
assign out[27:24] = {in[24], in[25], in[26], in[27]};

endmodule