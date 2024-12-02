// This handles addresses that do not map to real memory
module RAMManager (
    input wire [31:0] addr,
    input wire [31:0] RAMDataOut,
    input wire [31:0] sensorDataOut,
    output wire [31:0] dataOut);

assign dataOut = (addr == 32'h10000000) ? sensorDataOut : RAMDataOut
endmodule