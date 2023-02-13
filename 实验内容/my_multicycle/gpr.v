module gpr_32(Wd, RegWrite, Clk, Reset, A1, A2, A3, Rd1, Rd2);

    input [31:0] Wd;
    input RegWrite, Clk, Reset;
    input [4:0] A1, A2, A3;
    output [31:0] Rd1, Rd2;

    wire [31:0] Rd1, Rd2;
    reg [31:0] gpr[31:0];

    assign Rd1 = gpr[A1];
    assign Rd2 = gpr[A2];

    integer i;

    always @(posedge Clk)
    begin
        if (Reset) begin
            for(i=0; i<32; i=i+1)
                gpr[i] <= 32'h00000000;
        end
        else if (RegWrite) gpr[A3] <= Wd;
    end

    integer handle;

    
    initial
    begin
        #9990000
        handle = $fopen("gpr.txt","w"); 
        for(i=0; i<32; i=i+1)
            $fwrite(handle, "gpr[%d]=%h\n", i, gpr[i]);
        $fclose(handle);
    end
     //for output

endmodule