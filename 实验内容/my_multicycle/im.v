module im_4k(addr,dout);
    input [11:2] addr;
    output [31:0] dout;

    reg [31:0] im[1023:0];
    wire [31:0] dout;
    
    assign dout = im[addr[11:2]];

    initial begin
        $readmemh("code.txt", im, 0, 1023);
    end

endmodule