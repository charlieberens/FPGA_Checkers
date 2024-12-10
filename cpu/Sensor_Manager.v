module SensorManager(
    output [31:0] sensorDataOut,
    input clk,
    output sr_clk_wire,
    output parallel_mode_wire,
    input in_val,
    input v1,
    input v2
);
// Clock - JA[1]
// PL - JA[2]
// Input - JA[4]

// NOTE: Parallel is active low

reg[31:0] i, j, counter;
reg sr_clk, parallel_mode;
reg [63:0] val_reg;
reg has_been_released;
reg BTNC;

initial begin
    sr_clk = 1'b0;
    parallel_mode = 1'b0;
    i = 0;
    j = 0;
    counter = 0;
    val_reg = 0;
    has_been_released = 1;
    BTNC = 0;
end

always @(posedge clk) begin
    i = i + 1;
    if(i >= 32'd100) begin
        sr_clk = ~sr_clk;
        i = 0;
        j <= j + 1;

        if(j >= 256) begin
            BTNC <= ~BTNC;
            j <= 0;
        end
    end
end

always @(posedge sr_clk) begin
    if(!BTNC) begin
        has_been_released = 1'b1;
    end
    if(BTNC && has_been_released) begin
        counter = 0;
        parallel_mode = 1'b1;
        has_been_released = 1'b0;
    end else if(counter < 32) begin
        val_reg[counter] = in_val;
        counter = counter + 1;
    end else if(counter == 32) begin
        parallel_mode = 1'b0;
        val_reg[0] = in_val;
    end
end

//assign sensorDataOut[30:5] = ~val_reg[30:5];
//assign sensorDataOut[3:0] = ~val_reg[3:0];
//assign sensorDataOut[4] = ~v1;
//assign sensorDataOut[31] = ~v2;
assign sensorDataOut = val_reg[31:0];
assign sr_clk_wire = sr_clk;
assign parallel_mode_wire = parallel_mode;
endmodule