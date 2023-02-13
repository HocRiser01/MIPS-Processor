`timescale 1ns / 1ps
`include "ALU.v"
`include "DM.v"
`include "IM.v"
`include "GPR.v"
`include "EXT.v"
`include "NPC.v"
`include "PC.v"
`include "controller.v"
`include "mux_ALU.v"
`include "mux_GPR.v"
`include "mux_instr.v"
`include "mux_write.v"

module main;
	wire[15:0] imm;
	wire[31:2] next_pc, pc;
	wire[4:0] rs, rt, rd, A1, A2, A3;
	wire[11:2] add_dm;
	wire[31:0] dm_in, dm_out, im_out, sum, alu_out, ex_imm, b;
	wire[31:0] read_data1, read_data2, write_data;
	wire[11:2] add_im;
	wire[5:0] func,op;
	wire[1:0] aluop;
	wire[25:0] im_outs;
	wire[31:28] pc_s;
	wire[31:2] pc_plus, instr;
	wire zero, write_reg, alu_sel, ifbeq;
	wire in, out, dest, extop, sign, set_GPR, J, JR, JAL;
	reg clk,reset;

	controller controller(.func(func), .op(op), .aluop(aluop), .write_reg(write_reg),
		.alu_sel(alu_sel), .ifbeq(ifbeq), .in(in), .out(out), .dest(dest),
		.extop(extop), .sign(sign), .set_GPR(set_GPR), .J(J), .JAL(JAL), .JR(JR));
	ALU ALU(.a(read_data1), .b(b), .op(aluop), .sum(alu_out));
	NPC NPC(.ifbeq(ifbeq), .alu_out(alu_out), .now_pc(pc), .next_pc(next_pc), .offset(imm),
		.J(J), .instr(instr));
	PC PC(.next_pc(next_pc), .reset(reset), .clk(clk), .pc(pc));
	IM IM(.add_im(add_im), .im_out(im_out));
	mux_GPR mux_GPR(.rt(rt), .rd(rd), .dest(dest), .A3(A3));
	GPR GPR(.read_reg1(A1), .read_reg2(A2), .write_reg(A3), .write_data(write_data),
		.JAL(JAL), .op(write_reg), .set_GPR(set_GPR), .clk(clk),
		.read_data1(read_data1), .read_data2(read_data2), .pc_plus(pc_plus));
	EXT EXT(.extop(extop), .sign(sign), .a(imm), .res(ex_imm));
	mux_ALU mux_ALU(.read_data2(read_data2), .ex_imm(ex_imm),
		.alu_sel(alu_sel), .b(b));
	DM DM(.add_dm(add_dm), .dm_in(dm_in), .clk(clk),
		.in(in), .out(out), .dm_out(dm_out));
	mux_write mux_write(.alu_out(alu_out), .out(out),
		.dm_out(dm_out), .write_data(write_data));
	mux_instr mux_instr(.im_outs(im_outs), .pc_s(pc_s), .JR(JR),
		.instr(instr), .read_data1(read_data1));

	assign rs = im_out[25:21];
	assign rt = im_out[20:16];
	assign rd = im_out[15:11];
	assign op = im_out[31:26];
	assign func = im_out[5:0];
	assign imm = im_out[15:0]; 
	assign A1 = rs; 
	assign A2 = rt;
	assign add_im = pc[11:2];
	assign add_dm = alu_out[11:2];
	assign dm_in = read_data2;
	assign im_outs = im_out[25:0];
	assign pc_s = pc[31:28];
	assign pc_plus = pc + 1;

	initial
	begin
		clk = 0;
		reset = 1;
		#6 reset = 0;
		#100 $finish;
	end

	always 
	begin
		#5 clk = ~clk;
	end

	//test
	always @(GPR.gpr[1])
		$display("GPR[1]:%d", GPR.gpr[1]);

	always @(GPR.gpr[2])
		$display("GPR[2]:%d", GPR.gpr[2]);

	always @(GPR.gpr[3])
		$display("GPR[3]:%d", GPR.gpr[3]);

	always @(GPR.gpr[4])
		$display("GPR[4]:%d", GPR.gpr[4]);
	
	always @(GPR.gpr[5])
		$display("GPR[5]:%d", GPR.gpr[5]);

	always @(GPR.gpr[6])
		$display("GPR[6]:%d", GPR.gpr[6]);

	initial
	begin
		$dumpfile("main.vcd");
		$dumpvars(0, IM);
		$dumpvars(0, DM);
		$dumpvars(0, ALU);
		$dumpvars(0, GPR);
		$dumpvars(0, controller);
	end

endmodule