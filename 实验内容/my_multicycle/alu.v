module alu(A,B,F,C);
    input [31:0] A, B;
    input [3:0] F;
    output [31:0] C;

    wire [31:0] C;
    parameter op_or = 4'b0001, op_sub = 4'b0010, op_add = 4'b0011, op_and = 4'b0100;
    parameter op_xor = 4'b0101, op_nor = 4'b0110, op_scomp = 4'b0111, op_ucomp = 4'b1000; 
    parameter op_A = 4'b1001;

    assign  C = (F == op_or) ? (A|B) :
                (F == op_sub) ? (A-B) :
                (F == op_add) ? (A+B) :
                (F == op_and) ? (A&B) :
                (F == op_xor) ? (A^B) :
                (F == op_nor) ? (~(A|B)) :
                (F == op_scomp) ? {31'b0, ($signed(A)<$signed(B))} :
                (F == op_ucomp) ? {31'b0, ($unsigned(A)<$unsigned(B))} :
                (F == op_A) ? A : B;

endmodule