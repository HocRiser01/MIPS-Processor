module ALUMUX(in0, in1, choose, dout);
    input [31:0] in0, in1;
    input choose;
    output [31:0] dout;

    wire [31:0] dout;
    assign dout = (choose) ? in1 : in0;
endmodule