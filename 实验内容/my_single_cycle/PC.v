`timescale 1ns / 1ps

module PC(
		input[31:2] next_pc,
		input reset, clk,
		output reg[31:2] pc
	);

	always @(posedge clk)
	begin
		if (reset == 1) pc = 30'h00003000;
			else pc = next_pc;
	end
endmodule