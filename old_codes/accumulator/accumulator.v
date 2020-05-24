/*
	!!!! ----- ACCUMULATOR COUNTER MODULE ---- !!!!
	Design a state machine for accumulation of counters
	
	State:
		Addition 	(0)
		Subtraction (1)
		
	Inputs:
		clk
			binary
			clock generation
		
		rst
			binary
			reset acc (accumulation) value to 5'b0
			
		show
			binary
			save current value to acc
			
		mode
			binary
			0: addition
			1: subtraction
			
	Outputs:
		acc
			5 bits
			display values accumulated
*/

module accumulator
(
	// ---- declare PORTS & VARIABLES here! ---- //
	
	input	 wire			clk, rst, show, mode,
	output reg  [5:0] acc
	
	// ---- End of variables & ports declaration ---- //
);

/*	
--------------------------------------------
		declare internal variables here
*/

reg [5:0] count;

/*		
		end of internal declaration
---------------------------------------------
*/


/*
---------------------------------------------
		MODULE opertations here
*/
		
always@(posedge clk)
begin
	if (rst)
		begin
			acc	<= 5'b000_000;
			count <= 5'b000_000;
		end
	
	else
		begin
			if (mode) count <= count - 5'b000_001;
			else		 count <= count + 5'b000_001;
			
			if (show) acc <= count;
			else		 acc <= acc;
		end
end			
/*
		End of module operations
---------------------------------------------
*/

endmodule
