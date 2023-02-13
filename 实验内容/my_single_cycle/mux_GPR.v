`timescale 1ns / 1ps

module mux_GPR(
		input[4:0] rt, rd,
		input dest,
		output reg[4:0] A3
	);

	always @(rt or rd or dest)
		if (dest == 1) A3 = rd; else A3 = rt;
endmodule