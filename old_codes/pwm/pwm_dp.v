/*
	!!! --- PWM DATA PATH MODULE --- !!!
	
	Generate PWM signal with 2 counters
	
	Period counter:
		CNT_P == PERIOD --> reset PWM cycle
		
	Duty counter:
		CNT_D == DUTY --> PWM signal set to low
	
	!!! --- End of module specification --- !!!
*/

module PWM_DP
(
	input	wire			[7:0]	COUNTER_Q,
	input	wire			[1:0]	MUX_SEL,
	
	output	wire			[7:0]	COUNTER_D
);

// MUX 2to1
assign COUNTER_D = (MUX_SEL == 2'b01) ? COUNTER_Q + 8'b1 : 8'd0;

endmodule

