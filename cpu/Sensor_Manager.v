module SensorManager(
    output reg [31:0] sensorDataOut,
    inout[10:1] JA,
    input clk,
    output[15:0] LED
);
// Clock - JA[1]
// PL - JA[2]
// Input - JA[4]

// NOTE: Parallel is active low

reg[31:0] i, counter;
wire in_val;
reg sr_clk, parallel_mode;
reg [31:0] val_reg;
reg has_been_released;

initial begin
    sr_clk = 1'b0;
    parallel_mode = 1'b0;
    i = 0;
    counter = 0;
    val_reg = 0;
    has_been_released = 1;
end

always @(posedge clk) begin
    i = i + 1;
    if (i[0:5] == 6'b111111) begin
        sr_clk = ~sr_clk;

        if(i >= 32'd6000) begin
            parallel_mode = 1'b1;
            i = 0;
        end
    end
end

assign JA[1] = sr_clk;
assign JA[2] = parallel_mode;
assign in_val = JA[4];

assign LED[7:0] = val_reg[7:0];
assign LED[15] = sr_clk;
assign LED[14] = parallel_mode;
assign LED[13] = in_val;

always @(negedge sr_clk) begin
    if(!parallel_mode) begin
        has_been_released = 1'b1;
    end
    if(parallel_mode && has_been_released) begin
        counter = 0;
        has_been_released = 1'b0;
    end else if(counter < 32) begin
        val_reg[counter] = in_val;
        counter = counter + 1;
    end else if(counter == 32) begin
        parallel_mode = 1'b0;
    end
end
endmodule

module shift_register(
    inout[10:1] JA,
    input clk,
    input BTNC,
    output[15:0] LED
);

endmodule