`timescale 1ns / 1ps

module NPC(
		input ifbeq,
		input[31:0] alu_out,
		input[31:2] now_pc,
		input[15:0] offset,
		input J,
		input[31:2] instr,
		output reg[31:2] next_pc
	);

	reg[29:0] tmp;
	always @(ifbeq or alu_out or now_pc or offset or J or instr)
	begin
		if ((ifbeq == 0) && (J == 0)) next_pc = now_pc + 1;
		else if (J == 1) next_pc = instr;
		else if (alu_out == 0)
			begin
				tmp = $signed(offset);
				next_pc = tmp + now_pc;
			end
		else next_pc = now_pc + 1;
	end
endmodule