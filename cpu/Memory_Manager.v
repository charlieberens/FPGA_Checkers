// This handles addresses that do not map to real memory
module MemoryManager (
    input wire clock,
    input wire reset,
    input wire wEn,
    input wire [31:0] addr,
    input wire [31:0] dataIn,
    output wire [31:0] dataOut,
    output wire [31:0] playerBoardOut,
    output wire [31:0] cpuBoardOut,
    output wire [31:0] kingBoardOut,
    output wire [31:0] statusOut,
    input wire [31:0] sensorBoardIn
);

wire [31:0] computerTurnOut, sensorBoardOut, ramDataOut;
register Status(
    .clk(clock),
    .in_en(wEn && addr[15:0] == 16'h1000),
    .data_in(dataIn),
    .clr(reset),
    .data_out(statusOut)
);
register SensorBoard(
    .clk(clock),
    .in_en(1'b1),
    .data_in(sensorBoardIn),
    .clr(reset),
    .data_out(sensorBoardOut)
);
register PlayerBoard(
    .clk(clock),
    .in_en(wEn && addr[15:0] == 16'h1002),
    .data_in(dataIn),
    .clr(reset),
    .data_out(playerBoardOut)
);
register CPUBoard(
    .clk(clock),
    .in_en(wEn && addr[15:0] == 16'h1003),
    .data_in(dataIn),
    .clr(reset),
    .data_out(cpuBoardOut)
);
register KingBoard(
    .clk(clock),
    .in_en(wEn && addr[15:0] == 16'h1004),
    .data_in(dataIn),
    .clr(reset),
    .data_out(kingBoardOut)
);
RAM ProcMem(.clk(clock), 
    .wEn(wEn && !addr[12]),
    .addr(addr[11:0]), 
    .dataIn(dataIn), 
    .dataOut(ramDataOut));

always @(clock) begin
    // $display("%b, %b, %b, %b, %b", kingBoardOut, cpuBoardOut, playerBoardOut, sensorBoardOut, statusOut);
    if(wEn && addr[15:0] == 16'h1002) begin
        $display("%b %x", dataIn, addr);
    end
end

assign dataOut = (addr == 32'h1000) ? statusOut : (addr == 32'h1001) ? sensorBoardOut : (addr == 32'h1002) ? playerBoardOut : (addr == 32'h1003) ? cpuBoardOut : (addr == 32'h1004) ? kingBoardOut : ramDataOut;
endmodule