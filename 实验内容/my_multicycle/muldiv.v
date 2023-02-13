module muldiv_module(DA, DB, op, clk, we, HI, LO);

    input [31:0] DA, DB;
    input [2:0] op;
    input clk, we;
    output [31:0] HI, LO;

    reg [31:0] HI, LO;

    always @ (posedge clk)
    begin
        if (we)
            case(op)
                3'b000: {HI, LO} <= $signed(DA) * $signed(DB); //mult
                3'b001: {HI, LO} <= $unsigned(DA) * $unsigned(DB); //multu
                3'b010: 
                    begin
                        LO <= $signed(DA) / $signed(DB);
                        HI <= $signed(DA) % $signed(DB);
                    end //div
                3'b011:
                    begin
                        LO <= $unsigned(DA) / $unsigned(DB);
                        HI <= $unsigned(DA) % $unsigned(DB);
                    end //divu
                3'b100: HI <= DA; //write_HI
                3'b101: LO <= DA; //write_LO
            endcase
    end

endmodule