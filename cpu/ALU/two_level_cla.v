module two_level_cla(sum, cout, A, B, cin);
    input [31:0] A, B;
    input cin;
    output [31:0] sum;
    output cout;
    wire P0, G0, P1, G1, P2, G2, P3, G3, c8, c16, c24, c8_s1, c16_s1, c16_s2, c24_s1, c24_s2, c24_s3, cout_s1, cout_s2, cout_s3, cout_s4;
    //wire [31:0] neg_b, full, single, b;

    //assign full = 32'b11111111111111111111111111111111;
    //assign single = 32'b00000000000000000000000000000001;

    //xor negative(neg_b, B, full, single);

    //assign b = cin ? neg_b : B;

    eight_bit_block one(sum[7:0], P0, G0, A[7:0], B[7:0], cin);
    eight_bit_block two(sum[15:8], P1, G1, A[15:8], B[15:8], c8);
    eight_bit_block three(sum[23:16], P2, G2, A[23:16], B[23:16], c16);
    eight_bit_block four(sum[31:24], P3, G3, A[31:24], B[31:24], c24);

    and c8_step1(c8_s1, P0, cin);
    or eighth_carry(c8, G0, c8_s1);

    and c16_step1(c16_s1, P1, G0);
    and c16_step2(c16_s2, P1, P0, cin);
    or sixteenth_carry(c16, G1, c16_s1, c16_s2);

    and c24_step1(c24_s1, P2, G1);
    and c24_step2(c24_s2, P2, P1, G0);
    and c24_step3(c24_s3, P2, P1, P0, cin);
    or twentyfourth_carry(c24, G2, c24_s1, c24_s2, c24_s3);

    and cout_step1(cout_s1, P3, G2);
    and cout_step2(cout_s2, P3, P2, G1);
    and cout_step3(cout_s3, P3, P2, P1, G0);
    and cout_step4(cout_s4, P3, P2, P1, P0, cin);
    or c_out(cout, G3, cout_s1, cout_s2, cout_s3, cout_s4);

endmodule