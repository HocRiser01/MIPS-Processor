`timescale 1ns / 1ps

module GPR(
		input[4:0] read_reg1, read_reg2, write_reg,
		input[31:0] write_data,
		input op, clk, set_GPR, JAL,
		input[31:2] pc_plus,
		output reg[31:0] read_data1, read_data2
	);
	reg[31:0] gpr[31:0];

    always @(read_reg1 or read_reg2)
    begin
        read_data1 = gpr[read_reg1];
        read_data2 = gpr[read_reg2];
    end

    always @(posedge clk)
    begin
        if (op == 1)
        begin
            if (set_GPR == 0)
                if (JAL == 1) gpr[31] = pc_plus;
                    else gpr[write_reg] = write_data;
            else
                if (write_data[31] == 1) gpr[write_reg] = 1;
                    else gpr[write_reg] = 0;
        end
    end
    
    initial
    begin: seq_blk_a
        integer i;
        for (i = 0; i < 32; i += 1) gpr[i] = 0;
    end
endmodule