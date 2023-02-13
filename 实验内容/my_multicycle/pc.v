module pc_module(din, clock, pc_in, reset, dout);
    input [31:0] din;
    input clock, pc_in, reset;
    output [31:0] dout;
    wire [31:0] dout;
    reg [31:0] pc;

    assign dout = pc;

    always @(posedge clock)
        if (reset) pc <= 32'h00003000;
        else if (pc_in) pc <= din;

endmodule