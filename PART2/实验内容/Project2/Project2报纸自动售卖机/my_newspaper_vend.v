module vend_ctrl( coin, clock, reset, newspaper ) ;
	input   [1:0]   coin ;							  // sum of money
	input		   clock ;							 // system clock
	input		   reset ;							 // synchronous reset
	output		  newspaper ;						 // enough to get newspaper
	wire			newspaper ;						 
	
	// variables declaration
	reg	 [1:0]   fsm_state ;						 // money now
	
	// codes of state machine
	parameter   S0  = 2'b00 ;						   // 0 c
	parameter   S5  = 2'b01 ;						   // 5 c
	parameter   S10 = 2'b10 ;						   // 10 c
	parameter   S15 = 2'b11 ;						   // >=15 c
	// a coin
	parameter   COIN_0  = 2'b00 ;					   // 0 c
	parameter   COIN_5  = 2'b01 ;					   // 5 c
	parameter   COIN_10 = 2'b10 ;					   // 10 c

	// 
	assign  newspaper = (fsm_state == S15) ;			// enough to get newspaper
	
	//
	always  @( posedge clock )
		if ( reset )
			fsm_state <= S0 ;										   // reset
		else
			case ( fsm_state ) 
				S0  :   if	  ( coin == COIN_5 )  fsm_state <= S5 ;   // S0 --> S5 : get a 5-cent coin
						else if ( coin == COIN_10 ) fsm_state <= S10 ;  // S0 --> S10 : get a 10-cent coin
				S5  :   if	  ( coin == COIN_5 )   fsm_state <= S10 ;  // S5 --> S10 : get a 5-cent coin
						else if ( coin == COIN_10 )  fsm_state <= S15 ;  // S5 --> S15: get a 10-cent coin
				S10 :   if	  ( coin == COIN_5 )  fsm_state <= S15 ;  // S10 --> S15: get a 5-cent coin
						else if ( coin == COIN_10 ) fsm_state <= S15 ;  // S10 --> S15: get a 10-cent coin
				S15 :   fsm_state  <= S0 ;							  // next
				default : fsm_state <= S0 ;							 // next
			endcase

endmodule