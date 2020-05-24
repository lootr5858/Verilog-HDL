module counting
(
	input wire		  rst,
	input wire		  en,
	input wire [7:0] cnt_o,
	
	output reg [7:0] cnt_n,
	output wire		  reached
);

localparam [7:0] max_val = 8'd8;

assign reached = (cnt_o == max_val) ? 1'b1 : 1'b0;

always @ *
begin
	
	if (rst) cnt_n = 8'b0;
	
	else
	begin
	
		if (en)
		begin
			
			if (reached) cnt_n = 8'b0;
			else cnt_n = cnt_o + 8'b1;
		
		end
		
		else cnt_n = 8'b0;
	
	end

end

endmodule
		