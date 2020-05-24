/* ----------------------------------------
		!!! UART APB Control module !!!
	----------------------------------------
	
	Switch between RX & TX modes
	
*/

module uart_apb_cp
(
	// Inputs:
	input wire			rstn,
	input wire			sel,
	input wire [11:2] addr, 			 // partial register address
	input wire			en,				 // active HIGH enable for transfer control
	
	// Outputs:
	output reg	ready,
	output reg sel_ops,		// active HIGH to start tx/rx operations. addr: 0x00
	output reg sel_tr,		// active HIGH to set TX/RX mode.			addr: 0x04
	output reg sel_mode,		// active HIGH to ser 8/10 bit mode.		addr: 0x08
	output reg sel_baud		// active HIGH to set baudrate.				addr: 0x10
);

/* -------------------
	internal wires/regs
	------------------- */
	
	
/* ----------------
	conditions check
	---------------- */
	
	
/* -------------
	CONTROL Logic
	------------- */
always @ *
begin

	casex ({rstn, sel, en, addr})
	
		// Reset
		{1'b0, 1'bx, 1'bx, 10'bx}: begin
												ready    = 1'b0;
												sel_ops  = 1'b0;
												sel_tr   = 1'b0;
												sel_mode = 1'b0;
												sel_baud = 1'b0;
											end
											
		// Idling
		{1'b1, 1'b0, 1'bx, 10'bx}: begin
												ready    = 1'b1;
												sel_ops  = 1'b0;
												sel_tr   = 1'b0;
												sel_mode = 1'b0;
												sel_baud = 1'b0;
											end
		
		{1'b1, 1'bx, 1'b0, 10'bx}: begin
												ready    = 1'b1;
												sel_ops  = 1'b0;
												sel_tr   = 1'b0;
												sel_mode = 1'b0;
												sel_baud = 1'b0;
											end
		
		
		// enable OPERATING mode. addr: 0x00
		{1'b1, 1'b1, 1'b1, 10'h0}: begin
														ready    = 1'b0;
														sel_ops  = 1'b1;
														sel_tr   = 1'b0;
														sel_mode = 1'b0;
														sel_baud = 1'b0;
													end
		
		// set TX/RX ops. addr: 0x04
		{1'b1, 1'b1, 1'b1, 10'h4}: begin
												ready    = 1'b0;
												sel_ops  = 1'b0;
												sel_tr   = 1'b1;
												sel_mode = 1'b0;
												sel_baud = 1'b0;
											end
		
		// set 8/10 bit mode. addr: 0x08
		{1'b1, 1'b1, 1'b1, 10'h8}: begin
												ready    = 1'b0;
												sel_ops  = 1'b0;
												sel_tr   = 1'b0;
												sel_mode = 1'b1;
												sel_baud = 1'b0;
											end
		
		// set baudrate. addr: 0x10
		{1'b1, 1'b1, 1'b1, 10'h10}: begin
												ready    = 1'b0;
												sel_ops  = 1'b0;
												sel_tr   = 1'b0;
												sel_mode = 1'b0;
												sel_baud = 1'b1;
											end
		
	endcase

end

endmodule
