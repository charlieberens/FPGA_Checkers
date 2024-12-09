module LightController(
    input clk,              // System Clock Input 20 MHz
    input [31:0] playerPieces,
    input [31:0] cpuPieces,
    input [31:0] kingPieces,
    output out
);
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
        test_bits[23:0]    <= playerPieces[0]  ? (kingPieces[0]  ? LIGHT_BLUE : BLUE) : (cpuPieces[0]  ? (kingPieces[0] ? LIGHT_RED : RED) : NONE);
        test_bits[47:24]   <= playerPieces[1]  ? (kingPieces[1]  ? LIGHT_BLUE : BLUE) : (cpuPieces[1]  ? (kingPieces[1] ? LIGHT_RED : RED) : NONE);
        test_bits[71:48]   <= playerPieces[2]  ? (kingPieces[2]  ? LIGHT_BLUE : BLUE) : (cpuPieces[2]  ? (kingPieces[2] ? LIGHT_RED : RED) : NONE);
        test_bits[95:72]   <= playerPieces[3]  ? (kingPieces[3]  ? LIGHT_BLUE : BLUE) : (cpuPieces[3]  ? (kingPieces[3] ? LIGHT_RED : RED) : NONE);
        test_bits[119:96]  <= playerPieces[4]  ? (kingPieces[4]  ? LIGHT_BLUE : BLUE) : (cpuPieces[4]  ? (kingPieces[4] ? LIGHT_RED : RED) : NONE);
        test_bits[143:120] <= playerPieces[5]  ? (kingPieces[5]  ? LIGHT_BLUE : BLUE) : (cpuPieces[5]  ? (kingPieces[5] ? LIGHT_RED : RED) : NONE);
        test_bits[167:144] <= playerPieces[6]  ? (kingPieces[6]  ? LIGHT_BLUE : BLUE) : (cpuPieces[6]  ? (kingPieces[6] ? LIGHT_RED : RED) : NONE);
        test_bits[191:168] <= playerPieces[7]  ? (kingPieces[7]  ? LIGHT_BLUE : BLUE) : (cpuPieces[7]  ? (kingPieces[7] ? LIGHT_RED : RED) : NONE);
        test_bits[215:192] <= playerPieces[8]  ? (kingPieces[8]  ? LIGHT_BLUE : BLUE) : (cpuPieces[8]  ? (kingPieces[8] ? LIGHT_RED : RED) : NONE);
        test_bits[239:216] <= playerPieces[9]  ? (kingPieces[9]  ? LIGHT_BLUE : BLUE) : (cpuPieces[9]  ? (kingPieces[9] ? LIGHT_RED : RED) : NONE);
        test_bits[263:240] <= playerPieces[10] ? (kingPieces[10] ? LIGHT_BLUE : BLUE) : (cpuPieces[10] ? (kingPieces[10] ? LIGHT_RED : RED) : NONE);
        test_bits[287:264] <= playerPieces[11] ? (kingPieces[11] ? LIGHT_BLUE : BLUE) : (cpuPieces[11] ? (kingPieces[11] ? LIGHT_RED : RED) : NONE);
        test_bits[311:288] <= playerPieces[12] ? (kingPieces[12] ? LIGHT_BLUE : BLUE) : (cpuPieces[12] ? (kingPieces[12] ? LIGHT_RED : RED) : NONE);
        test_bits[335:312] <= playerPieces[13] ? (kingPieces[13] ? LIGHT_BLUE : BLUE) : (cpuPieces[13] ? (kingPieces[13] ? LIGHT_RED : RED) : NONE);
        test_bits[359:336] <= playerPieces[14] ? (kingPieces[14] ? LIGHT_BLUE : BLUE) : (cpuPieces[14] ? (kingPieces[14] ? LIGHT_RED : RED) : NONE);
        test_bits[383:360] <= playerPieces[15] ? (kingPieces[15] ? LIGHT_BLUE : BLUE) : (cpuPieces[15] ? (kingPieces[15] ? LIGHT_RED : RED) : NONE);
        test_bits[407:384] <= playerPieces[16] ? (kingPieces[16] ? LIGHT_BLUE : BLUE) : (cpuPieces[16] ? (kingPieces[16] ? LIGHT_RED : RED) : NONE);
        test_bits[431:408] <= playerPieces[17] ? (kingPieces[17] ? LIGHT_BLUE : BLUE) : (cpuPieces[17] ? (kingPieces[17] ? LIGHT_RED : RED) : NONE);
        test_bits[455:432] <= playerPieces[18] ? (kingPieces[18] ? LIGHT_BLUE : BLUE) : (cpuPieces[18] ? (kingPieces[18] ? LIGHT_RED : RED) : NONE);
        test_bits[479:456] <= playerPieces[19] ? (kingPieces[19] ? LIGHT_BLUE : BLUE) : (cpuPieces[19] ? (kingPieces[19] ? LIGHT_RED : RED) : NONE);
        test_bits[503:480] <= playerPieces[20] ? (kingPieces[20] ? LIGHT_BLUE : BLUE) : (cpuPieces[20] ? (kingPieces[20] ? LIGHT_RED : RED) : NONE);
        test_bits[527:504] <= playerPieces[21] ? (kingPieces[21] ? LIGHT_BLUE : BLUE) : (cpuPieces[21] ? (kingPieces[21] ? LIGHT_RED : RED) : NONE);
        test_bits[551:528] <= playerPieces[22] ? (kingPieces[22] ? LIGHT_BLUE : BLUE) : (cpuPieces[22] ? (kingPieces[22] ? LIGHT_RED : RED) : NONE);
        test_bits[575:552] <= playerPieces[23] ? (kingPieces[23] ? LIGHT_BLUE : BLUE) : (cpuPieces[23] ? (kingPieces[23] ? LIGHT_RED : RED) : NONE);
        test_bits[599:576] <= playerPieces[24] ? (kingPieces[24] ? LIGHT_BLUE : BLUE) : (cpuPieces[24] ? (kingPieces[24] ? LIGHT_RED : RED) : NONE);
        test_bits[623:600] <= playerPieces[25] ? (kingPieces[25] ? LIGHT_BLUE : BLUE) : (cpuPieces[25] ? (kingPieces[25] ? LIGHT_RED : RED) : NONE);
        test_bits[647:624] <= playerPieces[26] ? (kingPieces[26] ? LIGHT_BLUE : BLUE) : (cpuPieces[26] ? (kingPieces[26] ? LIGHT_RED : RED) : NONE);
        test_bits[671:648] <= playerPieces[27] ? (kingPieces[27] ? LIGHT_BLUE : BLUE) : (cpuPieces[27] ? (kingPieces[27] ? LIGHT_RED : RED) : NONE);
        test_bits[695:672] <= playerPieces[28] ? (kingPieces[28] ? LIGHT_BLUE : BLUE) : (cpuPieces[28] ? (kingPieces[28] ? LIGHT_RED : RED) : NONE);
        test_bits[719:696] <= playerPieces[29] ? (kingPieces[29] ? LIGHT_BLUE : BLUE) : (cpuPieces[29] ? (kingPieces[29] ? LIGHT_RED : RED) : NONE);
        test_bits[743:720] <= playerPieces[30] ? (kingPieces[30] ? LIGHT_BLUE : BLUE) : (cpuPieces[30] ? (kingPieces[30] ? LIGHT_RED : RED) : NONE);
        test_bits[767:744] <= playerPieces[31] ? (kingPieces[31] ? LIGHT_BLUE : BLUE) : (cpuPieces[31] ? (kingPieces[31] ? LIGHT_RED : RED) : NONE);
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
