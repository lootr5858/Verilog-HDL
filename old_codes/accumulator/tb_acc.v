/*
	!!!! ----- ACCUMULATOR SIMULATOR MODULE ---- !!!!
	Test for accumulator counter module
	
	Accumulator counter module
		6 bit counter with plus/minus operations
	
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

module tb_acc();

/*	
--------------------------------------------
		declare internal variables here
*/

reg		  clk, rst, show, mode;
wire [5:0] acc;

/*		
		end of internal declaration
---------------------------------------------
*/


/*
---------------------------------------------
		MODULE opertations here
*/

// Module for testing
accumulator DUT(.clk(clk), .rst(rst), .show(show), .mode(mode), .acc(acc));

// declare initial conditions
initial
begin
	clk  <= 0;
	show <= 0;
	mode <= 0;
end

// generate clock interval
always #20 clk = ~clk;

// Test operation
initial
begin
	#10
	rst  <= 1;
	show <= 1;
	
	#30
	rst  <= 0;
	
	#120
	mode <= 1;
	
	#80
	mode <= 0;
	
	#120
	$finish;
end			
/*
		End of module operations
---------------------------------------------
*/

endmodule
