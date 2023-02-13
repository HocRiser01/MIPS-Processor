module GPRWriteDataMUX(in0, in1, in2, in3, in4, in5, choose, dout);
    input [31:0] in0, in1, in2, in3, in4, in5;
    input [2:0] choose;
    output [31:0] dout;

    wire [31:0] dout;
    assign dout =   (choose==3'b000) ? in0 :
                    (choose==3'b001) ? in1 :
                    (choose==3'b010) ? in2 :
                    (choose==3'b011) ? in3 :
                    (choose==3'b100) ? in4 :
                    in5;
endmodule