module rx_ten_eight
(
	input wire			clk,
	input wire			rst,
	input wire			sel,
	input wire [19:0] baud,
	input wire			rx_en,
	input wire			rx_in,
	
	output wire [7:0] rx_data,
	output wire [9:0] data_o,
	output wire [9:0] bit_cnt_out,
	output wire			baud_clk
);

wire [9:0]  bit_cnto;
wire [9:0]  bit_cntn;
wire [19:0] baud_cnto;
wire [19:0] baud_cntn;
//wire		   baud_clk;

rx_ten_eight_cp rx_ten_eight_cp
(
	.rst		 (rst),
	.sel		 (sel),
	.rx_en	 (rx_en),
	.baud_clk (baud_clk),
	.bit_cnto (bit_cnto),
	
	.bit_cntn (bit_cntn)
);

rx_ten_eight_dp rx_ten_eight_dp
(
	.rst		 (rst),
	.rx_en	 (rx_en),
	.rx_in	 (rx_in),
	.bit_cnto (bit_cnto),
	
	.data_o  (data_o)
);

baud_counter baud_counter
(
	.rst		  (rst),
	.en		  (rx_en),
	.baud 	  (baud),
	.baud_cnto (baud_cnto),
	.baud_cntn (baud_cntn),
	.baud_clk  (baud_clk)
);

ten_eight ten_eight
(
	.data_o (data_o),
	.bit_cnto  (bit_cnto),
	
	.rx_data (rx_data)
);

PipeReg #(10) bit_cnt
(
	.CLK	(clk),
	.RST	(rst),
	.EN	(1'b1),
	.D		(bit_cntn),
	.Q		(bit_cnto)
);

PipeReg #(20) baud_cnt
(
	.CLK (clk),
	.RST (rst),
	.EN  (1'b1),
	.D	  (baud_cntn),
	.Q	  (baud_cnto)
);

assign bit_cnt_out = bit_cnto;

endmodule
