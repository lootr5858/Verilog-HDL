/*
	!!! --- ADDER MODULE --- !!!
	8-bit ADDER with an output register
	addtion of 2 inputs
	operating frequeny: 25Mhz
	
	inputs:
		wire
		8 bit
			A, B
		
	output:
		wire
		8 bit
			SUM
*/
module adder(
	// ---- declare PORTS & DATA TYPES here ---- //
	input  wire [7:0] A, B;
	output wire [7:0] SUM;
	);

// ---- define operations of ADDER here ---- //
assign SUM = A + B;
// ---- End of module functions ---- //

endmodule
