/* ----------------------------------------
		!!! UART APB Top module !!!
	----------------------------------------
	
	rx & tx 8/10 bit (depending on mode)
	rx & tx bit-by-bit according to baudrate
	
	Control Path:
	
	Data Path:
*/

module uart_apb
(
	// Essential Inputs:
	input wire			clk,
	input wire			rstn,
	input wire			sel,
	input wire [11:2] addr, 			 // partial register address
	input wire			en,				 // active HIGH enable for transfer control
	input wire			write_control,	 // active HIGH control to write to APB reg
	input wire [31:0] write_data,		 // data from SOC to APB
	
	// Essential Outputs:
	output wire [31:0] read_data,	// data from APB to SOC
	output wire			 ready,
	
	// TX Outputs:
	output wire tx_en,	// enable transmission
	output wire tx_out,	// transmitted data	
	
	// RX Inputs:
	input wire	rx_in,	// data received from other APB modules
	
	// RX Outputs:
	output wire	rx_en	// active HIGH enable to receive signals
);


/* -------------------
	internal wires/regs
	------------------- */
// Essential wires
wire 			mode_eight_ten; // switch between 8 bit & 10 bit transfer
wire [19:0] baud;

// Control reg
wire sel_ops;	// active HIGH to start tx/rx operations. addr: 0x00
wire sel_tr; 	// active HIGH to set TX/RX mode.			addr: 0x04
wire sel_mode; // active HIGH to ser 8/10 bit mode.		addr: 0x08
wire sel_baud;	// active HIGH to set baudrate.				addr: 0x10

wire sel_rx;	// active HIGH to enable RX module.
wire sel_tx;	//	active HIGH to enable TX module.
wire mode;		// switch b/w 8/10 bit modes.

// TX wires
wire [9:0] din;
wire		  set;		// set DUTY & PERIOD. enable PWM

// RX wires
wire [31:0] rx_data;


/* -----------------------
	connect RX & TX modules
	----------------------- */
uart_apb_cp cp
(
	// Inputs:
	.rstn (rstn),
	.sel 	(sel),
	.addr (addr), 			 // partial register address
	.en	(en),				 // active HIGH enable for transfer control
	
	// Outputs:
	.ready	 (ready),
	.sel_ops	 (sel_ops),		// active HIGH to start tx/rx operations. addr: 0x00
	.sel_tr	 (sel_tr),		// active HIGH to set TX/RX mode.			addr: 0x04
	.sel_mode (sel_mode),	// active HIGH to ser 8/10 bit mode.		addr: 0x08
	.sel_baud (sel_baud)		// active HIGH to set baudrate.				addr: 0x10
);

uart_apb_dp dp
(
	// Inputs:
	.rstn				(rstn),
	.sel				(sel),
	.en				(en),
	.write_data 	(write_data),
	.rx_data			(rx_data),
	.write_control (write_control),
	
	.sel_ops	 (sel_ops),		// active HIGH to start tx/rx operations. addr: 0x00
	.sel_tr	 (sel_tr),		// active HIGH to set TX/RX mode.			addr: 0x04
	.sel_mode (sel_mode),	// active HIGH to ser 8/10 bit mode.		addr: 0x08
	.sel_baud (sel_baud),	// active HIGH to set baudrate.				addr: 0x10

	// Outputs:
	.set	  	  (set),
	.rx_en  	  (rx_en),
	.sel_rx 	  (sel_rx),
	.sel_tx 	  (sel_tx),
	.din	  	  (din),
	.read_data (read_data),
	.mode	  	  (mode),
	.baud	  	  (baud)
);

apb_rx apb_rx
(
	// Inputs:
	.clk		(clk),
	.rstn		(rstn),
	.sel		(sel_rx),
	.rx_en	(rx_en),
	.mode		(mode),
	.baud		(baud),
	.rx_in	(rx_in),
	
	// Outputs:
	.rx_data (rx_data)
);

apb_tx apb_tx
(
	// Input:
	.clk	(clk),
	.rstn (rstn),		// active LOW to reset
	.sel	(sel_tx),		// activate apb_tx module
	.set	(set),		// set DUTY & PERIOD. enable PWM
	.mode (mode),		// switch between 8 bit & 10 bit tx
	.din	(din),		// input data for transmission
	.baud (baud),		// bauddiv
	
	// Output:
	.tx_en  (tx_en),	// enable transmission
	.tx_out (tx_out)	// transmitted data
);


/* ----------------
	connecting wires
	---------------- */



endmodule
	