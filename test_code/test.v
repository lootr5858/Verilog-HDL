module test
(
	input wire clk,
	input wire rstn,
	input wire en,
	
	input wire [7:0] in1,
	//input wire			in2,
	
	output wire [31:0] out1
);


/* ------------------------
	Essential internal wires
	------------------------ */
wire rst = ~rstn;


/* --------------
	Test variables
	-------------- */
localparam eight_bit = 8;
localparam four_bit  = 4;

/*reg d0;
reg d1;
reg d2;
reg d3;

reg [21:0] nd;*/

/* ----------
	Test Logic
	---------- */
/*always @ *
begin

	casex ({rstn, en})
	
		{1'b0, 1'bx}: begin
										out1 <= 32'd0;
										/*d0   <= 1'b0;
										d1	  <= 1'b0;
										d2   <= 1'b0;
										d3   <= 1'b0;
										nd   <= 22'b0;*
									end
		
		{1'b1, 1'b0}: out1 <= out1;
		
		{1'b1, 1'b1}: out1 <= in1[7:0];
		
	endcase
	
end*/

assign out1[7:0] = (rstn) ? ((en) ? in1 : out1) : 32'b0;

endmodule
