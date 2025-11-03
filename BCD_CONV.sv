module BCD_CONV(
	input [13:0] bin,
	output [15:0] BCD,
	input CLK
);
	reg [29:0] WS;
	reg [3:0] i;
	assign BCD = WS[29:14];
	
	always @(posedge CLK) begin
		WS[29:14] = 12'b0;
		WS[13:0] = bin[13:0];
		for(i = 0; i < 14; i=i+1) begin
			if(WS[17:14] > 4'b0100) begin
				WS[17:14] = WS[17:14] + 2'b11;
			end
			if(WS[21:18] > 4'b0100) begin
				WS[21:18] = WS[21:18] + 2'b11;
			end
			if(WS[25:22] > 4'b0100) begin
				WS[25:22] = WS[25:22] + 2'b11;
			end
			if(WS[29:26] > 4'b0100) begin
				WS[29:26] = WS[29:26] + 2'b11;
			end
			WS = WS << 1;
		end
	end

endmodule
