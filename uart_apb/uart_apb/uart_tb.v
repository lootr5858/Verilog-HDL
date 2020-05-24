/* 
	----------------------------------------
			!!! UART APB Testbench !!!
	----------------------------------------
	
*/

module uart_tb();


/* ------------------
	testbench variable
	------------------ */
localparam period = 5;
localparam cycle = period * 2;


/* ---------------
	Universal Input
	--------------- */
reg			clk;
reg			rstn;
reg [11:2] addr; 			 // partial register address


/* ----------------
	UART 1 variables
	---------------- */
// Essential Input
reg			u0_sel;
reg			u0_en;				 // active HIGH enable for transfer control
reg			u0_write_control;	 // active HIGH control to write to APB reg
reg [31:0]  u0_write_data;		 // data from SOC to APB

// Essential Output
wire [31:0] u0_read_data;	// data from APB to SOC
wire			u0_ready;

// Tx Output
wire u0_tx_en;	 	// enable transmission
wire u0_tx_out; 	// transmitted data

// Rx Input
wire	u0_rx_in;	// data received from other APB modules

// Rx output
wire	u0_rx_en;	// active HIGH enable to receive signals


/* ----------------
	UART 2 variables
	---------------- */
// Essential Input
reg			u1_sel;
reg			u1_en;				 // active HIGH enable for transfer control
reg			u1_write_control; // active HIGH control to write to APB reg
reg [31:0] u1_write_data;	 // data from SOC to APB

// Essential Output
wire [31:0] u1_read_data;	// data from APB to SOC
wire			u1_ready;

// Tx Output
wire u1_tx_en;	// enable transmission
wire u1_tx_out; 	// transmitted data

// Rx Input
wire	u1_rx_in;	// data received from other APB modules

// Rx output
wire	u1_rx_en;	// active HIGH enable to receive signals


/* ---------------------
	test module instances
	--------------------- */
uart_apb uart0
(
	// Essential Inputs:
	.clk				(clk),
	.rstn				(rstn),
	.sel				(u0_sel),
	.addr				(addr), 			 	 // partial register address
	.en				(u0_en),				 	 // active HIGH enable for transfer control
	.write_control (u0_write_control),	 // active HIGH control to write to APB reg
	.write_data		(u0_write_data),		 // data from SOC to APB
	
	// Essential Outputs:
	.read_data (u0_read_data),	// data from APB to SOC
	.ready	  (u0_ready),
	
	// TX Outputs:
	.tx_en  (u0_tx_en),	// enable transmission
	.tx_out (u0_tx_out),	// transmitted data	
	
	// RX Inputs:
	.rx_in (u0_rx_in),	// data received from other APB modules
	
	// RX Outputs:
	.rx_en (u0_rx_en)	// active HIGH enable to receive signals
);

uart_apb uart1
(
	// Essential Inputs:
	.clk				(clk),
	.rstn				(rstn),
	.sel				(u1_sel),
	.addr				(addr), 			 	 // partial register address
	.en				(u1_en),				 	 // active HIGH enable for transfer control
	.write_control (u1_write_control),	 // active HIGH control to write to APB reg
	.write_data		(u1_write_data),		 // data from SOC to APB
	
	// Essential Outputs:
	.read_data (u1_read_data),	// data from APB to SOC
	.ready	  (u1_ready),
	
	// TX Outputs:
	.tx_en  (u1_tx_en),	// enable transmission
	.tx_out (u1_tx_out),	// transmitted data	
	
	// RX Inputs:
	.rx_in (u1_rx_in),	// data received from other APB modules
	
	// RX Outputs:
	.rx_en (u1_rx_en)	// active HIGH enable to receive signals
);


/* ----------------
	Clock Generation
	---------------- */
initial clk <= 1'b1;
always #(period) clk <= ~clk;


/* -------------
	Reset Control
	------------- */
initial
begin
	
	rstn  <= 1'b0;
	
	#(cycle * 2)
	
	rstn <= 1'b1;

end


/* ----------------
	UART 0 <-> UART 1
	---------------- */
assign u0_rx_in = u1_tx_out;
assign u1_rx_in = u1_tx_out;


/* ----------------
	Simulation Logic
	---------------- */
initial
begin

	/* -----
		Reset
		----- */
	
	u0_sel				<= 1'b0;
	u0_en					<= 1'b0;
	u0_write_control  <= 1'b0;
	
	u1_sel				<= 1'b0;
	u1_en					<= 1'b0;
	u1_write_control  <= 1'b0;
	
	#(cycle * 4)
	
	
	/* -----------------
		UART 0 --> UART 1
		----------------- */
	
	// Set Baudrate. addr: 0x10
	
	addr <= 20'h10;
	
	u0_sel				<= 1'b1;
	u0_en					<= 1'b0;
	u0_write_control  <= 1'b0;
	u0_write_data		<= 32'd16;
	
	u1_sel				<= 1'b1;
	u1_en					<= 1'b0;
	u1_write_control  <= 1'b0;
	u1_write_data		<= 32'd16;
	
	#(cycle)
	
	u0_en					<= 1'b1;
	u0_write_control  <= 1'b1;
	
	u1_en					<= 1'b1;
	u1_write_control  <= 1'b1;
	
	#(cycle)
	
	// Dummy cycle
	
	addr <= 20'hx;
	
	u0_sel				<= 1'b0;
	u0_en					<= 1'b0;
	u0_write_control  <= 1'b0;
	u0_write_data		<= 32'bx;
	
	u1_sel				<= 1'b0;
	u1_en					<= 1'b0;
	u1_write_control  <= 1'b0;
	u1_write_data		<= 32'bx;
	
	#(cycle * 2)
	
	// Set 8/10 bit mode. addr: 0x08
	
	addr <= 20'h8;
	
	u0_sel				<= 1'b1;
	u0_en					<= 1'b0;
	u0_write_control  <= 1'b0;
	u0_write_data		<= 32'b0;
	
	u1_sel				<= 1'b1;
	u1_en					<= 1'b0;
	u1_write_control  <= 1'b0;
	u1_write_data		<= 32'b0;
	
	#(cycle)
	
	u0_en					<= 1'b1;
	u0_write_control  <= 1'b1;
	
	u1_en					<= 1'b1;
	u1_write_control  <= 1'b1;
	
	#(cycle)
	
	// Dummy cycle
	
	addr <= 20'hx;
	
	u0_sel				<= 1'b0;
	u0_en					<= 1'b0;
	u0_write_control  <= 1'b0;
	u0_write_data		<= 32'dx;
	
	u1_sel				<= 1'b0;
	u1_en					<= 1'b0;
	u1_write_control  <= 1'b0;
	u1_write_data		<= 32'dx;
	
	#(cycle * 2)
	
	// Set Tx/Rx mode. addr: 0x04
	// UART 0 TX: 01
	// UART 1 RX: 10
	
	addr <= 20'h4;
	
	u0_sel				<= 1'b1;
	u0_en					<= 1'b0;
	u0_write_control  <= 1'b0;
	u0_write_data		<= 32'b1;
	
	u1_sel				<= 1'b1;
	u1_en					<= 1'b0;
	u1_write_control  <= 1'b0;
	u1_write_data		<= 32'b10;
	
	#(cycle)
	
	u0_en					<= 1'b1;
	u0_write_control  <= 1'b1;
	
	u1_en					<= 1'b1;
	u1_write_control  <= 1'b1;
	
	#(cycle)
	
	// Dummy cycle
	
	addr <= 20'hx;
	
	u0_sel				<= 1'b0;
	u0_en					<= 1'b0;
	u0_write_control  <= 1'b0;
	u0_write_data		<= 32'bx;
	
	u1_sel				<= 1'b0;
	u1_en					<= 1'b0;
	u1_write_control  <= 1'b0;
	u1_write_data		<= 32'bx;
	
	#(cycle * 2)
	
	// Initiate operation. addr: 0x00
	// UART 0 TX
	// UART 1 RX
	
	addr <= 20'h0;
	
	u0_sel				<= 1'b1;
	u0_en					<= 1'b0;
	u0_write_control  <= 1'b0;
	u0_write_data		<= 32'd53;
	
	u1_sel				<= 1'b1;
	u1_en					<= 1'b0;
	u1_write_control  <= 1'b0;
	u1_write_data		<= 32'bx;
	
	#(cycle)
	
	u0_en					<= 1'b1;
	u0_write_control  <= 1'b1;
	
	u1_en					<= 1'b1;
	u1_write_control  <= 1'b1;
	
	#(cycle)
	
	u0_write_control <= 1'b0;
	u1_write_control <= 1'b0;
	
	# (cycle * 250)
	
	// Dummy cycle
	
	addr <= 20'hx;
	
	u0_sel				<= 1'b0;
	u0_en					<= 1'b0;
	u0_write_control  <= 1'b0;
	u0_write_data		<= 32'dx;
	
	u1_sel				<= 1'b0;
	u1_en					<= 1'b0;
	u1_write_control  <= 1'b0;
	u1_write_data		<= 32'dx;
	
	#(cycle * 2)
	
	
	/* -----------------
		UART 1 --> UART 0
		----------------- */
		
	
	
	

	
	$finish();

end

endmodule
