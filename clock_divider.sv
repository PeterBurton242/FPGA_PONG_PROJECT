module clockdivider(
	input in_clk,
	output out_clk
);
reg [17:0] cnt;
always @(posedge in_clk)
	begin
	if(cnt < 250000) cnt <= cnt + 1'b1;
	else cnt <= 1'b0;
	if(cnt > 125000) out_clk <= 1'b1;
	else out_clk <= 1'b0;
	end
endmodule