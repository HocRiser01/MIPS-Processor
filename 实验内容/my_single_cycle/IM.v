`timescale 1ns / 1ps

module IM(
		input[11:2] add_im,
		output reg[31:0] im_out
	);
	reg[31:0] im[1023:0];

	always @add_im
	begin
		im_out = im[add_im];
	end

	//test
	initial
	begin: seq_blk_a
		integer i;
		for (i = 0; i < 1024; i += 1) im[i] = 0;

		im[0] = 32'b10001100000000010000000000000100;
		im[1] = 32'b10001100000000100000000000001000;
		im[2] = 32'b00000000001000100001100000100001;
		im[3] = 32'b00000000010000110010000000100001;
		im[4] = 32'b00000000011001000010100000100001;
		im[5] = 32'b00000000100001010011000000100001;
	end

endmodule