module counter
(
	input	wire		clk,
	input	wire		rst,
	input	wire		en,
	
	output wire [7:0] val,
	output wire			reached
);

wire [7:0] cnt_o;
wire [7:0] cnt_n;

assign val = cnt_o;

counting counting
(
	.rst	 	(rst),
	.en	 	(en),
	.cnt_o 	(cnt_o),
	.cnt_n 	(cnt_n),
	.reached (reached)
);

PipeReg #(8) cnt
(
	.CLK (clk),
	.RST (rst),
	.EN  (1'b1),
	.D	  (cnt_n),
	.Q   (cnt_o)
);

endmodule
