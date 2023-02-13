`timescale 1ns / 1ps

module mux_ALU(
		input[31:0] read_data2, ex_imm,
		input alu_sel,
		output reg[31:0] b
	);

	always @(read_data2 or ex_imm)
	begin
		if (alu_sel == 1) b = ex_imm;
			else b = read_data2;
	end
endmodule