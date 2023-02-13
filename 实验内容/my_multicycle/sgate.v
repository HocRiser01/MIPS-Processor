module shift_gate(ALUout, SGateOP, s, dataout);

    input [31:0] ALUout;
    input [1:0] SGateOP;
    input [4:0] s;
    output [31:0] dataout;

    reg [31:0] dataout;

    always
    begin
        #5
        case(SGateOP)
            2'b00: dataout <= (ALUout << s);
            2'b01: dataout <= ALUout;
            2'b10: dataout <= (ALUout >> s);
            2'b11: dataout <= ($signed(ALUout) >>> s);
        endcase
    end

endmodule