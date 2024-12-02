module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	wire [31:0] write_decode, read_decode_one, read_decode_two;
	wire [31:0] reg_result, temp_dataA, temp_dataB, writeThroughA, writeThroughB;

	assign write_decode = ctrl_writeEnable << ctrl_writeReg;
	assign read_decode_one = 1'b1 << ctrl_readRegA;
	assign read_decode_two = 1'b1 << ctrl_readRegB;

	register first_reg(clock, 1'b0, 32'b00000000000000000000000000000000, ctrl_reset, reg_result[31:0]);
	assign writeThroughA = (ctrl_readRegA == ctrl_writeReg)&&ctrl_writeEnable && ctrl_readRegA!=5'b0;
	assign writeThroughB = (ctrl_readRegB == ctrl_writeReg)&&ctrl_writeEnable && ctrl_readRegB!=5'b0;

	assign data_readRegA = (read_decode_one[0] && !(writeThroughA)) ? reg_result : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	assign data_readRegB = (read_decode_two[0] && !(writeThroughB)) ? reg_result : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	//assign data_readRegA = read_decode_one[0] ? reg_result : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	//assign data_readRegB = read_decode_two[0] ? reg_result : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	assign data_readRegA = writeThroughA ? data_writeReg : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	assign data_readRegB = writeThroughB ? data_writeReg : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
	genvar j;
	generate
		for(j=1; j<32; j=j+1)begin
			wire [31:0] reg_result_two;
            register rest_reg(clock, write_decode[j], data_writeReg, ctrl_reset, reg_result_two[31:0]);
			assign data_readRegA = (read_decode_one[j] && !(writeThroughA)) ? reg_result_two : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
			assign data_readRegB = (read_decode_two[j] && !(writeThroughB)) ? reg_result_two : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;

			// assign data_readRegA = read_decode_one[j] ? reg_result_two : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
			// assign data_readRegB = read_decode_two[j] ? reg_result_two : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
        end
	endgenerate

	

	// we can read from 2 registers at a time and write to 1
	// all register data is 32 bits
	// decoders to determine which registers to write to and read from
	// clock is passed to all registers regardless
	
	// clear is asynchronous

	// is there a non-behavioral way to make the flip flops?

	// create D flip flop module --> for now we will use the provided dffe_ref
	// create register by using genvar loop to create 32 D flip flops and string them together with tri states to determine output or not
	// create reg file by using genvar loop to create 32 registers

	// finished in about 1.5 hours

	// add your code here

endmodule
