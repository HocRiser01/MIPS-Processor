module DMext(memword, ALUout, DMop, dataout);

    input [31:0] memword;
    input [1:0] ALUout;
    input [2:0] DMop;
    output [31:0] dataout;

    reg [31:0] dataout;

    always
    begin
        #5
        case(DMop[1:0])
            2'b00: begin
                case(ALUout)
                    2'b00: dataout[7:0] <= memword[7:0];
                    2'b01: dataout[7:0] <= memword[15:8];
                    2'b10: dataout[7:0] <= memword[23:16];
                    2'b11: dataout[7:0] <= memword[31:24];
                endcase
                if (DMop[2]) dataout[31:8] <= 24'b0;
                else dataout[31:8] <= {24{dataout[7]}};
            end
            2'b01: begin
                case(ALUout[1])
                    1'b0: dataout[15:0] <= memword[15:0];
                    1'b1: dataout[15:0] <= memword[31:16];
                endcase
                if (DMop[2]) dataout[31:16] <= 16'b0;
                else dataout[31:16] <= {16{dataout[15]}};
            end
            2'b11: dataout <= memword;
        endcase
    end

endmodule