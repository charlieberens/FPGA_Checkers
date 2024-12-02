module eight_bit_block(sum, p_out, g_out, a, b, cin);
    input [7:0] a, b;
    input cin;
    output [7:0] sum;
    output p_out, g_out;
    wire c1, c2, c3, c4, c5, c6, c7, g0, p0, g1, p1, g2, p2, g3, p3, g4, p4, g5, p5, g6, p6, g7, p7, c1_s1, c2_s1, c2_s2, c3_s1, c3_s2, c3_s3, c4_s1, c4_s2, c4_s3, c4_s4, c5_s1, c5_s2, c5_s3, c5_s4, c5_s5, c6_s1, c6_s2, c6_s3, c6_s4, c6_s5, c6_s6, c7_s1, c7_s2, c7_s3, c7_s4, c7_s5, c7_s6, c7_s7, g_s1, g_s2, g_s3, g_s4, g_s5, g_s6, g_s7;

    xor sum0(sum[0], cin, a[0], b[0]);
    xor sum1(sum[1], c1, a[1], b[1]);
    xor sum2(sum[2], c2, a[2], b[2]);
    xor sum3(sum[3], c3, a[3], b[3]);
    xor sum4(sum[4], c4, a[4], b[4]);
    xor sum5(sum[5], c5, a[5], b[5]);
    xor sum6(sum[6], c6, a[6], b[6]);
    xor sum7(sum[7], c7, a[7], b[7]);
    
    and g_zero(g0, a[0], b[0]);
    or p_zero(p0, a[0], b[0]);
    and g_one(g1, a[1], b[1]);
    or p_one(p1, a[1], b[1]);
    and g_two(g2, a[2], b[2]);
    or p_two(p2, a[2], b[2]);
    and g_three(g3, a[3], b[3]);
    or p_three(p3, a[3], b[3]);
    and g_four(g4, a[4], b[4]);
    or p_four(p4, a[4], b[4]);
    and g_five(g5, a[5], b[5]);
    or p_five(p5, a[5], b[5]);
    and g_six(g6, a[6], b[6]);
    or p_six(p6, a[6], b[6]);
    and g_seven(g7, a[7], b[7]);
    or p_seven(p7, a[7], b[7]);

    and carry1_step1(c1_s1, p0, cin);
    or first_carry(c1, g0, c1_s1);

    and carry2_step1(c2_s1, p1, g0);
    and carry2_step2(c2_s2, p1, p0, cin);
    or second_carry(c2, g1, c2_s1, c2_s2);

    and carry3_step1(c3_s1, p2, g1);
    and carry3_step2(c3_s2, p2, p1, g0);
    and carry3_step3(c3_s3, p2, p1, p0, cin);
    or thrid_carry(c3, g2, c3_s1, c3_s2, c3_s3);

    and carry4_step1(c4_s1, p3, g2);
    and carry4_step2(c4_s2, p3, p2, g1);
    and carry4_step3(c4_s3, p3, p2, p1, g0);
    and carry4_step4(c4_s4, p3, p2, p1, p0, cin);
    or fourth_carry(c4, g3, c4_s1, c4_s2, c4_s3, c4_s4);

    and carry5_step1(c5_s1, p4, g3);
    and carry5_step2(c5_s2, p4, p3, g2);
    and carry5_step3(c5_s3, p4, p3, p2, g1);
    and carry5_step4(c5_s4, p4, p3, p2, p1, g0);
    and carry5_step5(c5_s5, p4, p3, p2, p1, p0, cin);
    or fifth_carry(c5, g4, c5_s1, c5_s2, c5_s3, c5_s4, c5_s5);

    and carry6_step1(c6_s1, p5, g4);
    and carry6_step2(c6_s2, p5, p4, g3);
    and carry6_step3(c6_s3, p5, p4, p3, g2);
    and carry6_step4(c6_s4, p5, p4, p3, p2, g1);
    and carry6_step5(c6_s5, p5, p4, p3, p2, p1, g0);
    and carry6_step6(c6_s6, p5, p4, p3, p2, p1, p0, cin);
    or sixth_carry(c6, g5, c6_s1, c6_s2, c6_s3, c6_s4, c6_s5, c6_s6);

    and carry7_step1(c7_s1, p6, g5);
    and carry7_step2(c7_s2, p6, p5, g4);
    and carry7_step3(c7_s3, p6, p5, p4, g3);
    and carry7_step4(c7_s4, p6, p5, p4, p3, g2);
    and carry7_step5(c7_s5, p6, p5, p4, p3, p2, g1);
    and carry7_step6(c7_s6, p6, p5, p4, p3, p2, p1, g0);
    and carry7_step7(c7_s7, p6, p5, p4, p3, p2, p1, p0, cin);
    or seventh_carry(c7, g6, c7_s1, c7_s2, c7_s3, c7_s4, c7_s5, c7_s6, c7_s7);

    and outp(p_out, p7, p6, p5, p4, p3, p2, p1, p0);

    and outg_step1(g_s1, p7, g6);
    and outg_step2(g_s2, p7, p6, g5);
    and outg_step3(g_s3, p7, p6, p5, g4);
    and outg_step4(g_s4, p7, p6, p5, p4, g3);
    and outg_step5(g_s5, p7, p6, p5, p4, p3, g2);
    and outg_step6(g_s6, p7, p6, p5, p4, p3, p2, g1);
    and outg_step7(g_s7, p7, p6, p5, p4, p3, p2, p1, g0);
    or outg(g_out, g7, g_s1, g_s2, g_s3, g_s4, g_s5, g_s6, g_s6, g_s7);

endmodule