module bc_tb();

localparam period = 5;
localparam cycle = period * 2;

reg		  clk;
reg		  rstn;
reg		  en;
reg [19:0] baud;

wire [19:0] baud_counter;
wire			baud_clk;

baud_counter bc
(
	.clk			  (clk),
	.rstn			  (rstn),
	.en			  (en),
	.baud			  (baud),
	.baud_counter (baud_counter),
	.baud_clk	  (baud_clk)
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
	
	rstn <= 1'b0;
	
	#(cycle * 2)
	
	rstn <= 1'b1;

end

/* ------ !! ------
	 SIMULATION !!!
	------ !! ------ */
initial
begin

	baud <= 20'd20;
	
	#(cycle * 4)
	
	en <= 1'b1;
	
	#(cycle * 50)
	
	en <= 1'b0;
	
	#(cycle * 4)
	
	$finish();
end

endmodule
