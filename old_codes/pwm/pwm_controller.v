/*
	!!! --- PWM CONTROLLER TOP MODULE --- !!!
	
	Connect between DATA PATH & CONTROL PATH modules
	
	!!! --- End of module specification --- !!!
*/
	

module pwm_controller
(
	input	wire				CLK,
	input	wire				RST,
	output	wire				RDY,

	input	wire		[7:0]	PERIOD,
	input	wire		[7:0]	DUTY,

	input	wire				SET,
	input	wire				STOP,

	output	wire				PWM
);

	// Wires
	wire				[7:0]	PERIOD_Q;
	wire				[7:0]	DUTY_Q;

	wire						PERIOD_FF_EN;
	wire						DUTY_FF_EN;

	wire						BUSY;

	wire				[3:0]	STATE_D;
	wire				[3:0]	STATE_Q;

	wire				[1:0]	MUX_SEL;

	wire				[7:0]	COUNTER_D;
	wire				[7:0]	COUNTER_Q;
	wire						DUTY_REACH;

	// Registers
	PipeReg #(8) PERIOD_FF(
		.CLK		(CLK),
		.RST		(RST),
		.EN			(PERIOD_FF_EN),
		.D			(PERIOD - 8'b1),
		.Q			(PERIOD_Q)
	);	

	PipeReg #(8) DUTY_FF(
		.CLK		(CLK),
		.RST		(RST),
		.EN			(DUTY_FF_EN),
		.D			(DUTY - 8'b1),
		.Q			(DUTY_Q)
	);	

	PipeReg	#(2) STATE_FF(
		.CLK		(CLK),
		.RST		(RST),
		.EN			(1'b1),
		.D			(STATE_D),
		.Q			(STATE_Q)
	);

	PipeReg	#(8) COUNTER_FF(
		.CLK			(CLK),
		.RST			(RST),
		.EN				(1'b1),
		.D				(COUNTER_D),
		.Q				(COUNTER_Q)
	);

	// PWM datapath
	PWM_dp PWM_dp(
		.COUNTER_Q		(COUNTER_Q),
		.MUX_SEL		(MUX_SEL),

		.COUNTER_D		(COUNTER_D)
	);

	// FSM
	PWM_cp PWM_cp(
		.STATE_D		(STATE_D),
		.STATE_Q		(STATE_Q),

		.SET			(SET),
		.STOP			(STOP),
		.DUTY_REACH		(DUTY_REACH),

		.PERIOD_FF_EN	(PERIOD_FF_EN),
		.DUTY_FF_EN		(DUTY_FF_EN),
		.BUSY			(BUSY),
		.RDY			(RDY),
		.MUX_SEL		(MUX_SEL)
	);

	// Mics. assigns
	assign DUTY_REACH = (COUNTER_Q == PERIOD_Q) ? 1'b1 : 1'b0;	
	assign PWM = ((COUNTER_Q <= DUTY_Q) && BUSY) ? 1'b1 : 1'b0;

endmodule


