/*
	!!! --- 5 bit counter --- !!!
	
	------------------------------
	! - Interface Overview - !
	Inputs:
		clk (clock)
		rst (reset)
		match_in (matching value, 5 bit)
		
	Outputs:
		match_out (expiring value)
	------------------------------
	
	-----------------
	! - Operation - !
	1. clk high: increase 5-bit value
	2. rst high: resets 5 bit value to 5'b00000
	3. match_in = 5 bit value: match_out high
	-----------------
*/

module fivebitcounter(
	input  wire			clk, rst,
	input  wire  [4:0] match_in,
	output reg	[4:0] count,
	output reg			match_out
	);

// ---- 5 bit counter operations here ---- //
always@(posedge clk)
	begin
		if(rst) count <= 5'b0;
		else	  count <= count + 5'b1;
		
		
		if (count == match_in) match_out <= 1;
		else						  match_out <= 0;
	end
// ---- End of 5 bit counter operations here ---- //

endmodule
