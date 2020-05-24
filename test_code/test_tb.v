module test_tb();

// Constants of testbench
localparam period = 5;
localparam cycle	= period * 2;

// Testbench variable
reg clk;
reg rstn;
reg en;

// Input of test module
reg [7:0] in1;
//reg		  in2;

// Output of test module
wire [31:0] out1;


// create test module instance
test test1
(
	.clk  (clk),
	.rstn (rstn),
	.en	(en),
	
	.in1 (in1),
	//.in2 (in2),
	
	.out1(out1)
);

/* ----------------
	Clock Generation
	---------------- */
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

	#(cycle * 2)
	
	en = 1'b0;
	
	#(cycle * 2)
	
	in1 = 8'b0000_1111_0000_1111_0000_1111_0101_0101;
	
	#(cycle * 2)
	
	en = 1'b1;
	
	#(cycle * 2)
	
	en = 1'b0;
	
	#(cycle * 2)

	in1 = 32'b0000_1111_0000_1111_0000_1111_0011_1100;
	
	#(cycle * 2)
	
	en = 1'b1;
	
	#(cycle * 2)
	
	en = 1'b0;
	
	#(cycle * 2)
	
	$finish();
	
end

endmodule
