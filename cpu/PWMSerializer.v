/*
This module takes in a desired duty cycle percentage and the total width of the pulse,
and outputs a PWM signal with the specified duty cycle.

*/

module PWMSerializer #(
    parameter 
    // Parameters in nanoseconds
    PERIOD_WIDTH_NS = 1000,  // Total width of the period in nanoseconds
    SYS_FREQ_MHZ   = 100     // Base FPGA Clock in MHz; Nexys A7 uses a 100 MHz Clock
    )(
    input clk,              // System Clock
    input reset,            // Reset the counter
    //input [9:0] duty_cycle, // Duty Cycle of the Wave, between 0 and 1023 - scaled to 0 and 100
    input [1535:0] bits,
    output reg signal = 0   // Output PWM signal
    );
    
    // Convert PULSE_WIDTH_NS to clock cycles
    localparam num_bits = 1535; //1535 for 64 lights, 767 for 32 lights
    localparam PERIOD = (PERIOD_WIDTH_NS * SYS_FREQ_MHZ) / 1000; // Convert ns to clock cycles
    localparam PULSE_HALF   = PERIOD >> 1;
    localparam PULSE_BITS   = $clog2(PERIOD) + 1;
    
    // Counter to track pulse timing
    reg[PULSE_BITS-1:0] pulseCounter = 0;
    reg[9:0] duty_cycle = bits[num_bits] ? 10'd737 : 10'd286;
    reg[10:0] cycle_count = 0;
    reg delay = 0;
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            pulseCounter <= 0;
        end else begin
            if(pulseCounter < PERIOD - 1) begin
                pulseCounter <= pulseCounter + 1;
            end else begin
                pulseCounter <= 0;
                if(delay == 0)begin
                    cycle_count <= cycle_count+1;
                    if(cycle_count == num_bits)begin
                        delay <= 1;
                        cycle_count <= 0;
                        duty_cycle <= 0;
                    end else begin
                        duty_cycle <= bits[num_bits-1 - cycle_count] ? 10'd737 : 10'd286;
                    end
                end else begin
                    cycle_count <= cycle_count+1;
                    duty_cycle <= 0;
                    if(cycle_count == 100) begin
                        duty_cycle <= bits[num_bits] ? 10'd737 : 10'd286;
                        cycle_count <= 0;
                        delay <= 0;
                    end
                end
            end
        end
    end
    
    // The pulse is high when the counter is less than the calculated duty cycle count
    wire lessThan;
    reg delayerBit = 0;
    assign lessThan = pulseCounter < ((duty_cycle * PERIOD) / 1023);
    
    // Capture the lessThan signal on the negative edge after it has stabilized
    always @(negedge clk) begin
        signal <= lessThan;
    end
endmodule
