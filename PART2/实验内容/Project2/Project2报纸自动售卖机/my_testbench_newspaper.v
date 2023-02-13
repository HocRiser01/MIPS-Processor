`include "my_newspaper_vend.v"

module  testbench_ ;
	//
	reg	clock ;
	reg[1:0] coin ;
	reg	reset;
	wire newspaper;
	
	// instantiate the controller module
	vend_ctrl ctrl (
		.coin(coin), .clock(clock), .reset(reset), .newspaper(newspaper)
	);
	
	// Display the output
	initial
	begin
		$display( "\t\tTime Reset Newspaper\n" ) ;
		$monitor( "%d %d %d", $time, reset, newspaper ) ;
	end
		
	// 
	initial
	begin
		clock   = 0 ;
		coin	= 0 ;
		reset   = 1 ;					   // reset the controller
		#50 reset = 0 ;
		
		@(negedge clock) ;				  // wait for negative edge of the first clock
		
		// test the case of 3 5-cent coins
		#80 coin = 1 ;  #40 coin = 0 ;	  // 1st 5-cent coin
		#80 coin = 1 ;  #40 coin = 0 ;	  // 2nd 5-cent coin
		#80 coin = 1 ;  #40 coin = 0 ;	  // 3rd 5-cent coin
		
		// test the case of 5 --> 10
		#180 coin = 1 ;  #40 coin = 0 ;	 // 1st 5-cent coin
		#80 coin = 2 ;  #40 coin = 0 ;	  // 2nd 10-cent coin
		
		#80 $finish ;
	end
	
	always  
		#20 clock = ~clock ;

	initial
	begin			
		$dumpfile("my_newspaper_vend.vcd");
		$dumpvars(0, ctrl);
	end 

endmodule