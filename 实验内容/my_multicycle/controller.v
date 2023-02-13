module controller(clk, reset, instr, RegWrite, DMwe, ALUop, EXTop, MUX1choose, MUX2choose, MUX3choose, MUX4choose,
                  isj, isjr, BranchOP, SLTop, PC_in, IR_in, A_in, B_in, ALUout_in, DMout_in, DMop, SGateOP,
                  muldivOP, muldivWE);

    input clk, reset;
    input [31:0] instr;
    output RegWrite, DMwe;
    output [3:0] ALUop;
    output [1:0] EXTop, MUX1choose;
    output [2:0] MUX2choose;
    output MUX3choose;
    output [1:0] MUX4choose;
    output isj, isjr;
    output [2:0] BranchOP;
    output SLTop, PC_in, IR_in, A_in, B_in, ALUout_in, DMout_in;
    output [2:0] DMop;
    output [1:0] SGateOP;
    output [2:0] muldivOP;
    output muldivWE;

    wire [5:0] op, opp;

    wire is_add, is_addu, is_sub, is_subu, is_and, is_or, is_xor, is_nor;
    wire is_addi, is_addiu, is_andi, is_ori, is_xori;
    wire is_lw, is_sw, is_lb, is_lbu, is_sb, is_lh, is_lhu, is_sh, is_lui;
    wire is_slt, is_sltu, is_slti, is_sltiu;
    wire is_beq, is_bne, is_bgez, is_bgtz, is_blez, is_bltz;
    wire is_j, is_jal, is_jalr, is_jr; 
    wire is_mult, is_multu, is_div, is_divu, is_mfhi, is_mflo, is_mthi, is_mtlo;
    wire RegWrite, DMwe, MUX3choose, isj, isjr, SLTop, muldivWE;
    wire PC_in, IR_in, A_in, B_in, ALUout_in, DMout_in;
    wire [1:0] EXTop, MUX1choose, MUX4choose, SGateOP;
    wire [2:0] MUX2choose, BranchOP, DMop, muldivOP;
    wire [3:0] ALUop;

    parameter Fetch = 4'h0, RF = 4'h1, MA = 4'h2, MR = 4'h3;
    parameter MemWB = 4'h4, MW = 4'h5, Exe = 4'h6, WB = 4'h7;
    parameter Branch = 4'h8, Jmp = 4'h9;

    reg [3:0] nowState;

    initial
    begin
        nowState <= Fetch;
    end

    always @ (posedge clk)
    begin
        if (reset) nowState <= Fetch;
        else
        begin
            case(nowState)
                Fetch:
                    begin
                        nowState <= RF;
                    end
                RF:
                    begin
                        if (is_lw || is_sw || is_lb || is_lbu || is_sb || is_lh || is_lhu || is_sh) nowState <= MA;
                        else if (is_beq || is_bne || is_bgez || is_bgtz || is_blez || is_bltz) nowState <= Branch;
                        else if (is_j || is_jal || is_jalr || is_jr) nowState <= Jmp;
                        else nowState <= Exe; 
                    end
                MA:
                    begin
                        if (is_lw || is_lb || is_lbu || is_lh || is_lhu) nowState <= MR;
                        else nowState <= MW; //sw
                    end
                MR: nowState <= MemWB;
                MemWB: nowState <= Fetch;
                MW: nowState <= Fetch;
                Exe: nowState <= WB;
                WB: nowState <= Fetch;
                Branch: nowState <= Fetch;
                Jmp: nowState <= Fetch;
            endcase
        end
    end
    
    assign op = instr[31:26];
    assign opp = instr[5:0];

    assign is_add = ( (op == 6'b000000) && (opp == 6'b100000) );
    assign is_addu = ( (op == 6'b000000) && (opp == 6'b100001) );
    assign is_sub = ( (op == 6'b000000) && (opp == 6'b100010) );
    assign is_subu = ( (op == 6'b000000) && (opp == 6'b100011) );
    assign is_and = ( (op == 6'b000000) && (opp == 6'b100100) );
    assign is_or = ( (op == 6'b000000) && (opp == 6'b100101) );
    assign is_xor = ( (op == 6'b000000) && (opp == 6'b100110) );
    assign is_nor = ( (op == 6'b000000) && (opp == 6'b100111) );
    
    assign is_addi = (op == 6'b001000);
    assign is_addiu = (op == 6'b001001);
    assign is_andi = (op == 6'b001100);
    assign is_ori = (op == 6'b001101);
    assign is_xori = (op == 6'b001110);
    
    assign is_lui = (op == 6'b001111);
    
    assign is_slt = ( (op == 6'b000000) && (opp == 6'b101010) );
    assign is_sltu = ( (op == 6'b000000) && (opp == 6'b101011) );
    assign is_slti = (op == 6'b001010);
    assign is_sltiu = (op == 6'b001011);

    assign is_j = (op == 6'b000010);
    assign is_jal = (op == 6'b000011);
    assign is_jalr = ( (op == 6'b000000) && (opp == 6'b001001) );
    assign is_jr = ( (op == 6'b000000) && (opp == 6'b001000) );
    
    assign is_lw = (op == 6'b100011);
    assign is_sw = (op == 6'b101011);
    assign is_lb = (op == 6'b100000);
    assign is_lbu = (op == 6'b100100);
    assign is_lh = (op == 6'b100001);
    assign is_lhu = (op == 6'b100101);
    assign is_sb = (op == 6'b101000);
    assign is_sh = (op == 6'b101001);

    assign is_sll = ( (op == 6'b000000) && (opp == 6'b000000) );
    assign is_srl = ( (op == 6'b000000) && (opp == 6'b000010) );
    assign is_sra = ( (op == 6'b000000) && (opp == 6'b000011) );
    assign is_sllv = ( (op == 6'b000000) && (opp == 6'b000100) );
    assign is_srlv = ( (op == 6'b000000) && (opp == 6'b000110) );
    assign is_srav = ( (op == 6'b000000) && (opp == 6'b000111) );

    assign is_beq = (op == 6'b000100);
    assign is_bne = (op == 6'b000101);
    assign is_bgez = ( (op == 6'b000001) && (instr[20:16] == 5'b00001) );
    assign is_bgtz = (op == 6'b000111);
    assign is_blez = (op == 6'b000110);
    assign is_bltz = ( (op == 6'b000001) && (instr[20:16] == 5'b00000) );

    assign is_mult = ( (op == 6'b000000) && (opp == 6'b011000) );
    assign is_multu = ( (op == 6'b000000) && (opp == 6'b011001) );
    assign is_div = ( (op == 6'b000000) && (opp == 6'b011010) );
    assign is_divu = ( (op == 6'b000000) && (opp == 6'b011011) );
    assign is_mfhi = ( (op == 6'b000000) && (opp == 6'b010000) );
    assign is_mflo = ( (op == 6'b000000) && (opp == 6'b010010) );
    assign is_mthi = ( (op == 6'b000000) && (opp == 6'b010001) );
    assign is_mtlo = ( (op == 6'b000000) && (opp == 6'b010011) );

    assign RegWrite =   (nowState == WB && (!is_mult && !is_multu && !is_div && !is_divu && !is_mthi && !is_mtlo)) ||
                        (nowState == MemWB) || (nowState == Jmp && (is_jal || is_jalr));
    assign DMwe = (nowState == MW);

    assign ALUop =  (is_or || is_ori) ? 4'b0001 : //or
                    (is_sub || is_subu || is_beq || is_bne) ? 4'b0010 : //sub
                    (is_add || is_addu || is_addi || is_addiu || is_lw || is_sw || is_lb || is_lbu || is_sb || is_lh || is_lhu || is_sh) ? 4'b0011 : //add
                    (is_and || is_andi) ? 4'b0100 : //and
                    (is_xor || is_xori) ? 4'b0101 : //xor
                    (is_nor) ? 4'b0110 : //nor
                    (is_slt || is_slti) ? 4'b0111 : //signed compare
                    (is_sltu || is_sltiu) ? 4'b1000 : //unsigned compare
                    (is_bgez || is_bgtz || is_blez || is_bltz) ? 4'b1001 : //output A
                    4'b0000; //output B
    
    assign EXTop =  (is_addi || is_addiu || is_lw || is_sw || is_slti || is_sltiu || is_lb || is_lbu || is_sb || is_lh || is_lhu || is_sh) ? 2'b00 : //signed
                    (is_andi || is_ori || is_xori) ? 2'b01 : //unsigned
                    2'b10; //high(lui)
    
    assign MUX1choose = (is_addi || is_addiu || is_ori || is_lw || is_lb || is_lh || is_lbu || is_lhu || is_lui || is_slti || is_sltiu
                        || is_andi || is_xori) ? 2'b00 : //rt
                        (is_add || is_addu || is_sub || is_subu || is_and || is_or || is_xor || is_nor || is_slt || is_sltu || is_jalr
                        || is_sll || is_srl || is_sra || is_sllv || is_srlv || is_srav || is_mfhi || is_mflo) ? 2'b01 : //rd
                        (is_jal) ? 2'b10 : //5'b11111
                        2'b11;
    
    assign MUX2choose = (is_add || is_addu || is_sub || is_subu || is_ori || is_addi || is_addiu || is_lui
                        || is_and || is_or || is_xor || is_nor || is_andi || is_xori
                        || is_slt || is_sltu || is_slti || is_sltiu
                        || is_sll || is_srl || is_sra || is_sllv || is_srlv || is_srav) ? 3'b000 : //ALUout
                        (is_lw || is_lb || is_lh || is_lbu || is_lhu) ? 3'b001 : //DMout
                        (is_jal || is_jalr) ? 3'b010 : //PC+4
                        (is_mfhi) ? 3'b100 : //HI
                        (is_mflo) ? 3'b101 : //LO
                        3'b011; //SLTout
    
    assign MUX3choose = (is_andi || is_ori || is_xori || is_lui || is_addi || is_addiu || is_lw || is_sw || is_slti || is_sltiu
                        || is_lb || is_lbu || is_sb || is_lh || is_lhu || is_sh); //imm
    
    assign MUX4choose = (is_sll || is_srl || is_sra) ? 2'b00 : //imm
                        (is_sllv || is_srlv || is_srav) ? 2'b01 : //GPR[rs]
                        2'b10; //5'b00000
    
    assign isj = (is_j || is_jal);
    assign isjr = (is_jr || is_jalr);
    assign BranchOP =   (is_beq || is_bne || is_bgtz || is_blez) ? op[2:0] :
                        (is_bgez || is_bltz) ? {2'b01, instr[16]} :
                        3'b000;

    assign SLTop = (is_sltu || is_sltiu); // is unsigned?

    assign PC_in = (nowState == MemWB) || (nowState == MW) || (nowState == WB) || (nowState == Branch) || (nowState == Jmp);
    assign IR_in = (nowState == Fetch);
    assign A_in = (nowState == RF);
    assign B_in = (nowState == RF);
    assign ALUout_in = (nowState == MA) || (nowState == Exe);
    assign DMout_in = (nowState == MR);

    assign DMop[2] = (is_lbu || is_lhu); //u?
    assign DMop[1:0] = (is_lb || is_sb || is_lbu) ? 2'b00 :
                        (is_lh || is_sh || is_lhu) ? 2'b01 :
                        2'b11; //b,h,w
    
    assign SGateOP = opp[1:0];

    assign muldivOP = ((op == 6'b000000) && (opp[5:3] == 3'b011)) ? opp[2:0] : //mult, div
                      (is_mthi) ? 3'b100 : //mthi
                      (is_mtlo) ? 3'b101 : //mtlo
                      3'b000;
    
    assign muldivWE = (nowState == Exe && (is_mult || is_multu || is_div || is_divu || is_mthi || is_mtlo));

endmodule