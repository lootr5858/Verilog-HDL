/*
	!!! --- PWM CONTROL PATH MODULE --- !!!
	
	Control the generation of PWM Signals
	
	Input Controls:
		RST:  reset ENTIRE system
		SET:  start generation of PWM signal according to PERIOD & DUTY inputs
		STOP: stop pwm input signal
		
	Reset controls:
		RST_P:	reset period conters (CNT_P_O & CNT_P_N)
		RST_D:	reset duty counters (CNT_C_O & CNT_C_N)
		RST_PWM: set PWM signal to low
	
	!!! --- End of module specification --- !!!
*/

module pwm_cp
(
	input	wire		[3:0]	STATE_D,
	output	wire		[3:0]	STATE_Q,

	input	wire				SET,
	input	wire				STOP,
	input	wire				DUTY_REACH,

	output	wire				PERIOD_FF_EN,
	output	wire				DUTY_FF_EN,
	output	wire				BUSY,
	output	wire				RDY,
	output	wire		[1:0]	MUX_SEL
);
	localparam	ST_IDLE	= 2'b00;
	localparam	ST_SET	= 2'b01;
	localparam	ST_BUSY	= 2'b11;	

	reg [1+1+1+1+2+2-1:0] 	next_state;
	reg [3:0]				debug;
	
	assign {PERIOD_FF_EN, DUTY_FF_EN, BUSY, RDY, MUX_SEL, STATE_D} = next_state;

	always @*
		casex({STATE_Q, SET, STOP, DUTY_REACH})
			//		  SET	STOP  DRCH							 PEN   DEN   BUSY  RDY	 MUXSEL
			{ST_IDLE, 1'b0, 1'bx, 1'bx}: {next_state, debug} <= {1'b0, 1'b0, 1'b0, 1'b1, 2'b10, ST_IDLE, 	4'd0};	
			{ST_IDLE, 1'b1, 1'bx, 1'bx}: {next_state, debug} <= {1'b0, 1'b0, 1'b0, 1'b0, 2'b10, ST_SET, 	4'd1};	
			
			{ST_SET	, 1'bx, 1'bx, 1'bx}: {next_state, debug} <= {1'b1, 1'b1, 1'b0, 1'b0, 2'b10, ST_BUSY,	4'd2};	
			
			{ST_BUSY, 1'bx, 1'b0, 1'b0}: {next_state, debug} <= {1'b0, 1'b0, 1'b1, 1'b0, 2'b01, ST_BUSY,	4'd3};	
			{ST_BUSY, 1'bx, 1'b0, 1'b1}: {next_state, debug} <= {1'b0, 1'b0, 1'b1, 1'b0, 2'b10, ST_BUSY,	4'd3};	
			{ST_BUSY, 1'bx, 1'b1, 1'bx}: {next_state, debug} <= {1'b0, 1'b0, 1'b0, 1'b1, 2'b10, ST_IDLE,	4'd4};	
		endcase

endmodule