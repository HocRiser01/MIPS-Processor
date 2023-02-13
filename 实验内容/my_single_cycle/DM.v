`timescale 1ns / 1ps

module DM(
		input[11:2] add_dm,
		input[31:0] dm_in,
		input clk, in, out,
		output reg[31:0] dm_out
	);
	reg[31:0] dm[1023:0];

	always @(add_dm or out)
		if (out) dm_out = dm[add_dm];

	always @(posedge clk)
	begin
		if (in == 1) dm[add_dm] = dm_in;
		if (out == 1) dm_out = dm[add_dm];
	end

	initial
	begin: seq_blk_a
		integer i;
		for (i = 0; i < 1024; i += 1) dm[i] = 0;
		dm[1] = 1;
		dm[2] = 1;
	end
endmodule
