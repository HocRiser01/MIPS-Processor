`timescale 1ns / 1ps

module EXT(
        input extop, sign,
        input[15:0] a,
        output reg[31:0] res
    );

    always @(a or sign or extop)
    begin
        if (extop == 0) res = a << 16;
        else if (extop == 1 && sign == 0) res = a;
            else res = $signed(a);
    end
endmodule