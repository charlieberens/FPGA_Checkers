module LightController(
    input clk,              // System Clock Input 20 MHz
    input [31:0] playerPieces,
    input [31:0] cpuPieces,
    input [31:0] kingPieces,
    output out
);
    wire [31:0] playerPiecesRemapped, cpuPiecesRemapped, kingPiecesRemapped;

    transform trans_a(playerPieces, playerPiecesRemapped);
    transform trans_b(cpuPieces, cpuPiecesRemapped);
    transform trans_c(kingPieces, kingPiecesRemapped);

    // Fixed Duty Cycle for 0.9/1.25 ratio (approximately 737/1023)
    // localparam DUTY_CYCLE = 10'd737;
    localparam RED = 24'b000000001111111100000000;
    localparam GREEN = 24'b111111110000000000000000;
    localparam BLUE = 24'b000000000000000011111111;
    
    localparam LIGHT_BLUE = {8'd255, 8'd0, 8'd255};
    localparam LIGHT_RED = {8'd60, 8'd255, 8'd0};
    localparam WHITE = 24'b111111111111111111111111;
    
    localparam NONE = 24'b000000000000000000000000;
//    localparam NONE = 24'b111111110000000000000000;
    
    localparam TOTAL_BITS_IN = 32*24;
    reg [TOTAL_BITS_IN-1:0] test_bits = {16{RED, WHITE}};//{RED, WHITE, BLUE, RED, WHITE};
    wire [(2*TOTAL_BITS_IN)-1:0] adjusted_bits;
    wire [(2*TOTAL_BITS_IN)-1:0] snake_adjusted_bits;
    
    genvar j;
    
    generate 
        for(j=1; j<=64; j=j+1)begin
            if((j)%2 == 0)begin
                assign adjusted_bits[(24*j)-1 : 24*(j-1)] = test_bits[(24*((j-1)/2))+23 : 24*((j-1)/2)];
            end else begin
                assign adjusted_bits[(24*j)-1 : 24*(j-1)] = NONE;
            end
        end
    endgenerate

    always @(posedge clk) begin
        test_bits[23:0]    <= playerPiecesRemapped[0]  ? (kingPiecesRemapped[0]  ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[0]  ? (kingPiecesRemapped[0] ? LIGHT_RED : RED) : NONE);
        test_bits[47:24]   <= playerPiecesRemapped[1]  ? (kingPiecesRemapped[1]  ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[1]  ? (kingPiecesRemapped[1] ? LIGHT_RED : RED) : NONE);
        test_bits[71:48]   <= playerPiecesRemapped[2]  ? (kingPiecesRemapped[2]  ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[2]  ? (kingPiecesRemapped[2] ? LIGHT_RED : RED) : NONE);
        test_bits[95:72]   <= playerPiecesRemapped[3]  ? (kingPiecesRemapped[3]  ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[3]  ? (kingPiecesRemapped[3] ? LIGHT_RED : RED) : NONE);
        test_bits[119:96]  <= playerPiecesRemapped[4]  ? (kingPiecesRemapped[4]  ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[4]  ? (kingPiecesRemapped[4] ? LIGHT_RED : RED) : NONE);
        test_bits[143:120] <= playerPiecesRemapped[5]  ? (kingPiecesRemapped[5]  ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[5]  ? (kingPiecesRemapped[5] ? LIGHT_RED : RED) : NONE);
        test_bits[167:144] <= playerPiecesRemapped[6]  ? (kingPiecesRemapped[6]  ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[6]  ? (kingPiecesRemapped[6] ? LIGHT_RED : RED) : NONE);
        test_bits[191:168] <= playerPiecesRemapped[7]  ? (kingPiecesRemapped[7]  ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[7]  ? (kingPiecesRemapped[7] ? LIGHT_RED : RED) : NONE);
        test_bits[215:192] <= playerPiecesRemapped[8]  ? (kingPiecesRemapped[8]  ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[8]  ? (kingPiecesRemapped[8] ? LIGHT_RED : RED) : NONE);
        test_bits[239:216] <= playerPiecesRemapped[9]  ? (kingPiecesRemapped[9]  ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[9]  ? (kingPiecesRemapped[9] ? LIGHT_RED : RED) : NONE);
        test_bits[263:240] <= playerPiecesRemapped[10] ? (kingPiecesRemapped[10] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[10] ? (kingPiecesRemapped[10] ? LIGHT_RED : RED) : NONE);
        test_bits[287:264] <= playerPiecesRemapped[11] ? (kingPiecesRemapped[11] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[11] ? (kingPiecesRemapped[11] ? LIGHT_RED : RED) : NONE);
        test_bits[311:288] <= playerPiecesRemapped[12] ? (kingPiecesRemapped[12] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[12] ? (kingPiecesRemapped[12] ? LIGHT_RED : RED) : NONE);
        test_bits[335:312] <= playerPiecesRemapped[13] ? (kingPiecesRemapped[13] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[13] ? (kingPiecesRemapped[13] ? LIGHT_RED : RED) : NONE);
        test_bits[359:336] <= playerPiecesRemapped[14] ? (kingPiecesRemapped[14] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[14] ? (kingPiecesRemapped[14] ? LIGHT_RED : RED) : NONE);
        test_bits[383:360] <= playerPiecesRemapped[15] ? (kingPiecesRemapped[15] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[15] ? (kingPiecesRemapped[15] ? LIGHT_RED : RED) : NONE);
        test_bits[407:384] <= playerPiecesRemapped[16] ? (kingPiecesRemapped[16] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[16] ? (kingPiecesRemapped[16] ? LIGHT_RED : RED) : NONE);
        test_bits[431:408] <= playerPiecesRemapped[17] ? (kingPiecesRemapped[17] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[17] ? (kingPiecesRemapped[17] ? LIGHT_RED : RED) : NONE);
        test_bits[455:432] <= playerPiecesRemapped[18] ? (kingPiecesRemapped[18] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[18] ? (kingPiecesRemapped[18] ? LIGHT_RED : RED) : NONE);
        test_bits[479:456] <= playerPiecesRemapped[19] ? (kingPiecesRemapped[19] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[19] ? (kingPiecesRemapped[19] ? LIGHT_RED : RED) : NONE);
        test_bits[503:480] <= playerPiecesRemapped[20] ? (kingPiecesRemapped[20] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[20] ? (kingPiecesRemapped[20] ? LIGHT_RED : RED) : NONE);
        test_bits[527:504] <= playerPiecesRemapped[21] ? (kingPiecesRemapped[21] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[21] ? (kingPiecesRemapped[21] ? LIGHT_RED : RED) : NONE);
        test_bits[551:528] <= playerPiecesRemapped[22] ? (kingPiecesRemapped[22] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[22] ? (kingPiecesRemapped[22] ? LIGHT_RED : RED) : NONE);
        test_bits[575:552] <= playerPiecesRemapped[23] ? (kingPiecesRemapped[23] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[23] ? (kingPiecesRemapped[23] ? LIGHT_RED : RED) : NONE);
        test_bits[599:576] <= playerPiecesRemapped[24] ? (kingPiecesRemapped[24] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[24] ? (kingPiecesRemapped[24] ? LIGHT_RED : RED) : NONE);
        test_bits[623:600] <= playerPiecesRemapped[25] ? (kingPiecesRemapped[25] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[25] ? (kingPiecesRemapped[25] ? LIGHT_RED : RED) : NONE);
        test_bits[647:624] <= playerPiecesRemapped[26] ? (kingPiecesRemapped[26] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[26] ? (kingPiecesRemapped[26] ? LIGHT_RED : RED) : NONE);
        test_bits[671:648] <= playerPiecesRemapped[27] ? (kingPiecesRemapped[27] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[27] ? (kingPiecesRemapped[27] ? LIGHT_RED : RED) : NONE);
        test_bits[695:672] <= playerPiecesRemapped[28] ? (kingPiecesRemapped[28] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[28] ? (kingPiecesRemapped[28] ? LIGHT_RED : RED) : NONE);
        test_bits[719:696] <= playerPiecesRemapped[29] ? (kingPiecesRemapped[29] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[29] ? (kingPiecesRemapped[29] ? LIGHT_RED : RED) : NONE);
        test_bits[743:720] <= playerPiecesRemapped[30] ? (kingPiecesRemapped[30] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[30] ? (kingPiecesRemapped[30] ? LIGHT_RED : RED) : NONE);
        test_bits[767:744] <= playerPiecesRemapped[31] ? (kingPiecesRemapped[31] ? LIGHT_BLUE : BLUE) : (cpuPiecesRemapped[31] ? (kingPiecesRemapped[31] ? LIGHT_RED : RED) : NONE);
    end
    
    PWMSerializer #(
        .PERIOD_WIDTH_NS(1250), // 1.25 microseconds
        .SYS_FREQ_MHZ(100)      // 20 MHz system clock  
    ) pwm_instance (
        .clk(clk),
        .reset(1'b0),           // No reset functionality in this example
        // .duty_cycle(DUTY_CYCLE),// Set duty cycle for 0.9 microseconds high time
        .bits(adjusted_bits),
        .signal(out)         // Output signal
    );
endmodule
