module  c_tb();

localparam period = 5;
localparam cycle = period * 2;

reg		clk;
reg		rst;
reg		en;

wire [7:0] val;
wire		  reached;

counter counter
(
	.clk		(clk),
	.rst		(rst),
	.en		(en),
	.val		(val),
	.reached (reached)
);


/* ------ !! ------
	Clock generation
	------ !! ------ */
initial clk <= 1'b1;
always #(period) clk <= ~clk;

/* ------ !! ------
	 Reset COntrol
	------ !! ------ */
initial
begin
	
	rst <= 1'b1;
	
	#(cycle * 2)
	
	rst <= 1'b0;

end

/* ------ !! ------
	 SIMULATION !!!
	------ !! ------ */
initial
begin

	#(cycle * 4)
	
	en <= 1'b1;
	
	#(cycle * 26)
	
	en <= 1'b0;
	
	#(cycle * 2)
	
	$finish();
end

endmodule
