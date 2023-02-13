module dm_4k(addr, be, din, we, clk, dout);
    input [12:2] addr;
    input [3:0] be;
    input [31:0] din;
    input we, clk;
    output [31:0] dout;

    wire [31:0] dout;
    reg [31:0] dm[2047:0];

    assign dout = dm[addr];

    integer i;

    initial
    begin
        for(i=0; i<2048; i=i+1)
            dm[i]=32'h00000000;
    end

    always @(posedge clk)
        if (we)
        begin
            case(be)
                4'b1111: dm[addr] <= din;
                4'b0011: dm[addr][15:0] <= din[15:0];
                4'b1100: dm[addr][31:16] <= din[15:0];
                4'b0001: dm[addr][7:0] <= din[7:0];
                4'b0010: dm[addr][15:8] <= din[7:0];
                4'b0100: dm[addr][23:16] <= din[7:0];
                4'b1000: dm[addr][31:24] <= din[7:0];
            endcase
        end

    integer handle;

    initial
    begin
        #9980000
        handle = $fopen("dm.txt","w"); 
        for(i=0; i<32; i=i+1)
            $fwrite(handle, "dm[%d]=%h\n", i, dm[i]);
        $fclose(handle);
    end

endmodule