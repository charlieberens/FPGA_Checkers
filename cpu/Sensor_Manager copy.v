module SensorManager(
    output reg [31:0] sensorDataOut,
    output sr_clk_wire,
    output parallel_mode_wire,
    input in_val,
    input clk,
    input sensor1
);
// Clock - JA[1]
// PL - JA[2]
// Input - JA[3]

// NOTE: Parallel is active low

reg[31:0] i, counter;
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
   sensorDataOut = 32'b0;
end

always @(posedge clk) begin
    i <= i + 1;
    if (i == 32'b111111) begin
        sr_clk <= ~sr_clk;

        if(i >= 32'd8000) begin
            parallel_mode <= 1;
            i <= 0;
        end 
    end
end

always @(negedge clk) begin
            if(!parallel_mode) begin
                has_been_released <= 1;
            end
            if(parallel_mode && has_been_released) begin
                counter <= 0;
                has_been_released <= 0;
            end else if(counter < 32) begin
                val_reg[counter] <= in_val;
                counter <= counter + 1;
            end else if(counter == 32) begin
                parallel_mode <= 0;
                sensorDataOut <= val_reg;
            end
        end
end

assign sr_clk_wire = sr_clk;
assign parallel_mode_wire = parallel_mode;
endmodule