/* ----------------------------------------
		!!! UART APB Data module !!!
	----------------------------------------
	
	transfer write_data to respective registers
	
*/

module uart_apb_dp
(
	// Inputs:
	input wire 			rstn,
	input wire			sel,
	input wire 			en,
	input wire [31:0] write_data,
	input wire [9:0]  rx_data,
	input wire			write_control,
	
	input wire sel_ops,	// active HIGH to start tx/rx operations. addr: 0x00
	input wire sel_tr,	// active HIGH to set TX/RX mode.			addr: 0x04
	input wire sel_mode,	// active HIGH to ser 8/10 bit mode.		addr: 0x08
	input wire sel_baud,	// active HIGH to set baudrate.				addr: 0x10

	// Outputs:
	output reg			set,
	output reg			rx_en,
	output reg			sel_rx,
	output reg			sel_tx,
	output reg [9:0]  din,
	output reg [31:0] read_data,
	output reg			mode,
	output reg [19:0] baud
);

/* -------------------
	internal wires/regs
	------------------- */
reg  [1:0] tr_mode;
wire 		 tx;
wire		 rx;

	
/* ----------------
	conditions check
	---------------- */

	
	
/* -------------
	CONTROL Logic
	------------- */
assign tx = tr_mode[0];
assign rx = tr_mode[1];	

always @ *
begin

	casex ({rstn, write_control, sel_ops, sel_tr, sel_mode, sel_baud, tx, rx})
	
		// Reset
		{1'b0, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx, 1'bx}: begin
																				sel_rx <= 1'b0;
																				sel_tx <= 1'b0;
																				set 	 <= 1'b0;
																				rx_en  <= 1'b0;
																				din	 <= 10'bx;
																				mode	 <= 1'b0;
																				baud	 <= 20'bx;
																			end
		
		
		// enable OPERATING mode. addr: 0x00
			// setting
		{1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'bx, 1'bx}: begin
																				// select Tx / Rx
																				sel_tx <= tx;
																				sel_rx <= rx;
																		
																				// Set din
																				din <= write_data[9:0];
																			end
																			
			// transmitting ...
		{1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0}: begin
																				set 		 <= 1'b1;
																				rx_en 	 <= 1'b0;
																		  end
																			
			// receiving ...
		{1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1}: begin
																				set 				<= 1'b0;
																				rx_en 			<= 1'b1;
																				read_data[9:0] <= rx_data;
																			end
		
		// set TX/RX mode. addr: 0x04	
		{1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'bx, 1'bx}: tr_mode <= write_data[1:0];
		
		// set 8/10 bit mode. addr: 0x08	
		{1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'bx, 1'bx}: mode <= write_data[0];
	
		// set baudrate. addr: 0x10	
		{1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'bx, 1'bx}: baud <= write_data[19:0];


	endcase

end

endmodule
