module be_module(ALUout, DMop, BEout);
    input [1:0] ALUout, DMop;
    output [3:0] BEout;

    wire [3:0] BEout;

    assign BEout[3] = (DMop == 2'b11) || (DMop == 2'b01 && ALUout[1] == 1'b1) || (DMop == 2'b00 && ALUout == 2'b11);
    assign BEout[2] = (DMop == 2'b11) || (DMop == 2'b01 && ALUout[1] == 1'b1) || (DMop == 2'b00 && ALUout == 2'b10);
    assign BEout[1] = (DMop == 2'b11) || (DMop == 2'b01 && ALUout[1] == 1'b0) || (DMop == 2'b00 && ALUout == 2'b01);
    assign BEout[0] = (DMop == 2'b11) || (DMop == 2'b01 && ALUout[1] == 1'b0) || (DMop == 2'b00 && ALUout == 2'b00);

endmodule