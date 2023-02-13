module GPRWriteRegMUX(in0, in1, in2, choose, dout);
    input [4:0] in0, in1, in2;
    input [1:0] choose;
    output [4:0] dout;

    wire [4:0] dout;
    assign dout =   (choose==2'b00) ? in0 :
                    (choose==2'b01) ? in1 :
                    (choose==2'b10) ? in2 :
                    5'b00000;
endmodule