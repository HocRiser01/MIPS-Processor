`timescale 1ns / 1ps

module mux_instr(
		input[25:0] im_outs,
		input[31:28] pc_s,
		input[31:0] read_data1,
		input JR,
		output reg[31:2] instr
	);

	always @(im_outs or pc_s or read_data1 or JR)
	begin
		if (JR == 1) instr = read_data1[31:2];
		else instr = {pc_s, im_outs, 2'b00};
	end
endmodule