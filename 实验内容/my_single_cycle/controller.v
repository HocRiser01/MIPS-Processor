`timescale 1ns / 1ps

module controller(
		input[5:0] func,op,
		output reg[1:0] aluop,
		output reg write_reg, alu_sel, ifbeq, in, out, dest,
		output reg extop, sign, set_GPR, J, JAL, JR
	);
	reg addu, subu, ori, lw, sw, beq, lui, addi, slt, j, jal, jr;

	always @(func or op)
	begin
        addu = 0; addi = 0; subu = 0; ori = 0;
		lw = 0; sw = 0; beq = 0; lui = 0;
		slt = 0; j = 0; jal = 0; jr = 0; extop = 1; sign = 1; set_GPR = 0;

		if ((op == 6'b0) && (func == 6'b100001)) addu=1;
    		else if ((op == 6'b0) && (func == 6'b100011)) subu=1;
    		else if ((op == 6'b001101)) ori=1;
    		else if ((op == 6'b100011)) lw=1;
    		else if ((op == 6'b101011)) sw=1;
    		else if ((op == 6'b000100)) beq=1;
    		else if ((op == 6'b001111)) lui=1;
    		else if ((op == 6'b001000) || (op == 6'b001001)) addi=1;
    		else if ((op == 6'b000000) || (func == 6'b101010)) slt=1;
		if (op == 6'b000010) j=1;
		if (op == 6'b000011) jal=1;
		if ((op == 6'b000000) && (func == 6'b001000)) jr=1;
		if (lui == 1) sign=0;
		if (lui == 1) extop=0;
		if ((addu == 1) || (subu == 1) || (slt == 1)) dest=1;
		if ((addu == 1) || (subu == 1) || (lui == 1) || (lw == 1) || (ori == 1)
            || (addi == 1) || (jal == 1) || (slt == 1)) write_reg=1;
		if ((lui == 1) || (ori == 1) || (lw == 1) || (sw == 1) || (addi == 1)) alu_sel=1;
		if (beq == 1) ifbeq=1;
		if (sw == 1) in=1;
		if (lw == 1) out=1;
		if ((addu == 1) || (lw == 1) || (sw == 1) || (addi == 1)) aluop=3;
		if ((subu == 1) || (beq == 1) || (slt == 1)) aluop=2;
		if (ori == 1) aluop=1;
		if (slt == 1) set_GPR=1;
		if ((j == 1) || (jal == 1) || (jr == 1)) J=1;
		if (jal == 1) JAL=1;
		if (jr == 1) JR=1;
	end
endmodule