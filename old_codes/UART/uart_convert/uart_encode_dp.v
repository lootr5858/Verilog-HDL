module uart_encode_dp
(
	input wire			clk,
	input wire			rst,
	input wire			sel_tr,
	input wire			sel_ctrl,
	input wire			sel_baud,
	input wire			enable,
	input wire [31:0] data_out,
	input wire			rx_in,
	
	output reg [31:0] data_in,
	output wire	      tx_en,
	output wire			tx_out,
	output wire	[9:0] bit_cnt,
	output wire [9:0] tx_d,
	output wire [9:0] rx_d
);

reg		 sel_t;
reg		 sel_r;
reg [7:0] din;
wire [7:0] dout;
reg [6:0] tr_ctrl;
reg [19:0] baud;
//wire [9:0] bit_cnt;

tx_eight_ten tx_eight_ten
(
	.clk	(clk),
	.rst	(rst),
	.sel	(sel_t),
	.set	(enable),
	.din	(din),
	.baud (baud),
	
	.tx_en  (tx_en),
	.tx_out (tx_out),
	.tx_d	  (tx_d)
);

rx_ten_eight rx_ten_eight
(
	.clk	 (clk),
	.rst	 (rst),
	.sel	 (sel_r),
	.baud  (baud),
	.rx_en (enable),
	.rx_in (rx_in),
	
	.bit_cnt_out (bit_cnt),
	.rx_data (dout),
	.data_o  (rx_d)
);

always @ *
begin

	if (rst)
	begin
		
		data_in = 32'bx;
		sel_t	  = 1'b0;
		sel_r	  = 1'b0;
		din	  = 8'bx;
		tr_ctrl = 7'b0;
		baud	  = 20'bx;
		
	end
	
	else
	begin
		
		if (enable)
		begin
		
			if (sel_tr)
			begin
				
				if (tr_ctrl == 7'b0000_001) // transmit
				begin
					
					sel_t = 1'b1;
					sel_r = 1'b0;
					
					din[0] = data_out[0];
					din[1] = data_out[1];
					din[2] = data_out[2];
					din[3] = data_out[3];
					din[4] = data_out[4];
					din[5] = data_out[5];
					din[6] = data_out[6];
					din[7] = data_out[7];
					
				end
				
				else if	(tr_ctrl == 7'b0000_010) // receive
				begin
				
					sel_t = 1'b0;
					sel_r = 1'b1;
					
							
					if (bit_cnt == 10'd11)
					begin
					
						data_in	  = 32'b0;
						data_in[0] = dout[0];
						data_in[1] = dout[1];
						data_in[2] = dout[2];
						data_in[3] = dout[3];
						data_in[4] = dout[4];
						data_in[5] = dout[5];
						data_in[6] = dout[6];
						data_in[7] = dout[7];
					
					end
					
				end
			
			end
		
			else if (sel_ctrl)
			begin
					
				tr_ctrl[0] = data_out[0];
				tr_ctrl[1] = data_out[1];
				tr_ctrl[2] = data_out[2];
				tr_ctrl[3] = data_out[3];
				tr_ctrl[4] = data_out[4];
				tr_ctrl[5] = data_out[5];
				tr_ctrl[6] = data_out[6];
				
			end
			
			else if (sel_baud)
			begin
			
				baud[0] = data_out[0];
				baud[1] = data_out[1];
				baud[2] = data_out[2];
				baud[3] = data_out[3];
				baud[4] = data_out[4];
				baud[5] = data_out[5];
				baud[6] = data_out[6];
				baud[7] = data_out[7];
				baud[8] = data_out[8];
				baud[9] = data_out[9];
				baud[10] = data_out[10];
				baud[11] = data_out[11];
				baud[12] = data_out[12];
				baud[13] = data_out[13];
				baud[14] = data_out[14];
				baud[15] = data_out[15];
				baud[16] = data_out[16];
				baud[17] = data_out[17];
				baud[18] = data_out[18];
				baud[19] = data_out[19];
				
			end
				
			
		end
		
	end
	
end

endmodule
