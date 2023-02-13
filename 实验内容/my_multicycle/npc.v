module npc_module(pcin, imm, fromrs, isj, isjr, BranchOP, alu_zero, alu_sign, npc, pcout);
    input [31:0] pcin;
    input [25:0] imm;
    input [31:0] fromrs;
    input isj, isjr;
    input [2:0] BranchOP;
    input alu_zero, alu_sign;
    output [31:0] npc;
    output [31:0] pcout;
    wire [31:0] npc, pcout;

    wire [31:0] EXT_out;
    ext_module ext_(imm[15:0], 2'b00, EXT_out);

    assign npc =    (isjr) ? fromrs :
                    (isj) ? {pcin[31:28],imm,2'b00} :
                    (BranchOP == 3'b100 && alu_zero) ? (pcin + 32'h00000004 + {EXT_out,2'b00}) : //beq
                    (BranchOP == 3'b101 && !alu_zero) ? (pcin + 32'h00000004 + {EXT_out,2'b00}) : //bne
                    (BranchOP == 3'b011 && !alu_sign) ? (pcin + 32'h00000004 + {EXT_out,2'b00}) : //bgez
                    (BranchOP == 3'b111 && !alu_sign && !alu_zero) ? (pcin + 32'h00000004 + {EXT_out,2'b00}) : //bgtz
                    (BranchOP == 3'b110 && (alu_sign || alu_zero)) ? (pcin + 32'h00000004 + {EXT_out,2'b00}) : //blez
                    (BranchOP == 3'b010 && alu_sign) ? (pcin + 32'h00000004 + {EXT_out,2'b00}) : //bltz
                    (pcin + 32'h00000004);
    assign pcout = pcin + 32'h00000004;

endmodule