// This handles addresses that do not map to real memory
module MemoryManager (
    input wire wEn,
    input wire [31:0] addr,
    input wire [31:0] dataIn,
    output wire [31:0] dataOut,
    output wire [31:0] playerBoardOut,
    output wire [31:0] cpuBoardOut,
    output wire [31:0] kingBoardOut,
    input wire [31:0] computerTurnIn,
    input wire [31:0] sensorBoardIn,
    input wire computerTurnWEn,
);

wire [31:0] computerTurnOut, sensorBoardOut, ramDataOut;
register SensorBoard(
    .clock(clock),
    .in_en(1'b1),
    .data_in(sensorBoardIn),
    .clr(reset),
    .data_out(sensorBoardOut)
);
register ComputerTurn(
    .clock(clock),
    .in_en((wEn && addr[15:0] == 16'h1001) || computerTurnWEn),
    .data_in(computerTurnWEn ? computerTurnIn : dataIn),
    .clr(reset),
    .data_out(computerTurnOut)
);
register PlayerBoard(
    .clock(clock),
    .in_en(wEn && addr[15:0] == 16'h1002),
    .data_in(dataIn),
    .clr(reset),
    .data_out(playerBoardOut)
);
register CPUBoard(
    .clock(clock),
    .in_en(wEn && addr[15:0] == 16'h1003),
    .data_in(dataIn),
    .clr(reset),
    .data_out(cpuBoardOut)
);
register KingBoard(
    .clock(clock),
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

assign dataOut = (addr == 32'h1000) ? sensorBoardOut : (addr == 32'h1001) ? computerTurnOut : (addr == 32'h1002) ? playerBoardOut : (addr == 32'h1003) ? cpuBoardOut : (addr == 32'h1004) ? kingBoardOut : ramDataOut;
endmodule