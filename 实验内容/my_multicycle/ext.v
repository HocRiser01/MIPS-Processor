module ext_module(A,EXTop,B);
    input [15:0] A;
    input [1:0] EXTop;
    output [31:0] B;
    wire [31:0] B;

    parameter op_signed = 2'b00;
    parameter op_unsigned = 2'b01;
    parameter op_high = 2'b10;

    assign  B = (EXTop==op_signed) ? {{16{A[15]}},A} :
                (EXTop==op_unsigned) ? {16'h0000,A} :
                (EXTop==op_high) ? {A,16'h0000} :
                32'bz;

endmodule