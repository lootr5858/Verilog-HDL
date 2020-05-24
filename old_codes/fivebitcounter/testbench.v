module testbench();

// ---- Declare PORTS & DATA types here ---- //
reg  		  clk, rst;
reg  [4:0] match_in;
wire [4:0] count;
wire       match_out;
// ---- End declarations ---- //

// ---- module for testing ---- //
fivebitcounter DUT(.clk(clk), .rst(rst), .match_in(match_in), .count(count), .match_out(match_out));
// ---- End of module call ---- //

// --- Generate initial conditions ---- //
initial
begin
	clk <= 0;
	match_in <= 5'b00100;
end
// --- End of intial conditions ---- //

// ---- Clock generation: 25MHz ---- //
always #20 clk = ~clk;
// ---- End of clock generation ---- //

// ---- Test bench operations begin ---- //
initial
begin
	rst <= 1;
	
	#30
	rst <= 0;
	
	#1000;
	$finish;
end

endmodule
