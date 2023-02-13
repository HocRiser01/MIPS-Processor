`include "testbench.v"
`include "alu.v"
`include "be.v"
`include "controller.v"
`include "dm.v"
`include "dmext.v"
`include "ext.v"
`include "gpr.v"
`include "im.v"
`include "muldiv.v"
`include "npc.v"
`include "pc.v"
`include "sgate.v"
`include "SGateMUX.v"
`include "ALUMUX.v"
`include "GPRWriteRegMUX.v"
`include "GPRWriteDataMUX.v"

module mips(clk, reset);

    input clk, reset;

    wire ALUzero, isj, isjr, RegWrite, DMwe, MUX3choose, SLTop, muldivWE;
    wire [1:0] EXTop, MUX1choose, MUX4choose, SGateOP;
    wire [2:0] MUX2choose, BranchOP, DMop, muldivOP; 
    wire [3:0] BEout, ALUop;
    wire [4:0] GPRWriteReg, SGate_s;
    wire [31:0] pc_in, pc_out, NPCout, instr, HI, LO;
    wire [31:0] GPRWriteData, ReadData1, ReadData2, EXTout, ALUin, IR_wire;
    wire [31:0] ALUout_wire, DMout_wire, DMEXTout, SLTin, SLTout, SGateout;
    reg [31:0] IR, A, B, ALUout, DMout;

    wire PC_in, IR_in, A_in, B_in, ALUout_in, DMout_in;

    controller controller_i(clk, reset, instr, RegWrite, DMwe, ALUop, EXTop, MUX1choose, MUX2choose, MUX3choose, MUX4choose,
                            isj, isjr, BranchOP, SLTop, PC_in, IR_in, A_in, B_in, ALUout_in, DMout_in, DMop, SGateOP,
                            muldivOP, muldivWE);
    //输入：时钟，重置，指令；输出：全部信号
    pc_module U_PC(pc_in, clk, PC_in, reset, pc_out);
    //输入：新PC，时钟，写信号，重置；输出：新PC
    im_4k U_IM(pc_out[11:2], IR_wire);
    //输入：地址；输出：指令
    npc_module U_NPC(pc_out, instr[25:0], A, isj, isjr, BranchOP, ALUzero, SGateout[31], pc_in, NPCout);
    //输入：各种可能影响PC值的信号；输出：NPC，PC+4
    assign instr = IR;

    GPRWriteRegMUX MUX1(instr[20:16], instr[15:11], 5'h1F, MUX1choose, GPRWriteReg);
    //输入：指令中可能指代写寄存器编号的位置；输出：写寄存器编号
    GPRWriteDataMUX MUX2(ALUout, DMout, NPCout, SLTout, HI, LO, MUX2choose, GPRWriteData);
    //输入：可能写入寄存器的所有结果；输出：写入寄存器的数据

    gpr_32 U_RF(GPRWriteData, RegWrite, clk, reset, instr[25:21], instr[20:16], GPRWriteReg, ReadData1, ReadData2);
    //输入：需写入的数据，写信号，时钟，重置，两个读寄存器编号，一个写寄存器编号；输出：读出的两个数据
    
    ext_module U_EXT(instr[15:0], EXTop, EXTout);
    //输入：指令，扩展方式；输出：扩展后数值

    ALUMUX MUX3(B, EXTout, MUX3choose, ALUin);
    //输入：B和EXTout；输出：送入ALU的值
    
    alu U_ALU(A, ALUin, ALUop, ALUout_wire);
    //输入：A, B, op；输出：运算结果
    SGateMUX MUX4(instr[10:6], A[4:0], 5'h00, MUX4choose, SGate_s);
    //输入：可能成为位移位数的几个值；输出：位移位数
    shift_gate U_SGate(ALUout_wire, SGateOP, SGate_s, SGateout);
    //输入：ALU运算结果，位移方式，位移位数；输出：位移结果

    assign ALUzero = (SGateout == 32'h00000000);
    muldiv_module U_MULDIV(A, B, muldivOP, clk, muldivWE, HI, LO);
    //输入：A, B, op, clk, 写使能；输出：HI, LO
    
    dm_4k U_DM(ALUout[12:2], BEout, B, DMwe, clk, DMout_wire);
    //输入：地址，be，输入数据，写使能，时钟；输出：DM输出
    be_module U_BE(ALUout[1:0], DMop[1:0], BEout);
    //输入：ALUout, DMop，输出：be
    DMext U_DMext(DMout_wire, ALUout[1:0], DMop, DMEXTout);
    //输入：DM输出，ALU输出，DMop；输出：扩展后结果

    always @ (posedge clk)
    begin
        if (reset)
        begin
            IR <= 32'h00000000;
            A <= 32'h00000000;
            B <= 32'h00000000;
            ALUout <= 32'h00000000;
            DMout <= 32'h00000000;
        end
        else
        begin
            if (IR_in) IR <= IR_wire;
            if (A_in) A <= ReadData1;
            if (B_in) B <= ReadData2;
            if (ALUout_in) ALUout <= SGateout;
            if (DMout_in) DMout <= DMEXTout;
        end
    end

endmodule