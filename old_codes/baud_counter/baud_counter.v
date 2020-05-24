module baud_counter
(
	input wire			clk,
	input wire			rstn,
	input wire			en,
	input wire [19:0] baud,
	
	output wire [19:0] baud_counter,
	output wire			 baud_clk
);

wire [19:0] baud_cnto;
wire [19:0] baud_cntn;
wire rst;

assign baud_counter = baud_cnto;
assign rst = ~rstn;

counter counter
(
	.rstn 		(rstn),
	.en		   (en),
	.baud       (baud),
	.baud_cnto  (baud_cnto),
	.baud_cntn  (baud_cntn),
	.baud_clk	(baud_clk)
);

PipeReg #(20) baud_cnt
(
	.CLK (clk),
	.RST (rst),
	.EN  (1'b1),
	.D	  (baud_cntn),
	.Q	  (baud_cnto)
);

endmodule
