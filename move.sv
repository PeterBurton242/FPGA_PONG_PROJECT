module moveball(
	input clk,
	input [9:0] lpad,
	input [9:0] rpad,
	output reg [13:0] out_score,
	output reg [9:0] x_location,
	output reg [9:0] y_location,
	output reg xbounce
	);
	reg ybounce;
always @(posedge clk)
	begin
		//if it is at the right hand side and strikes the right paddle
		if ((y_location + 15 > (rpad)) && (y_location < (rpad + 85)) && (x_location == 605-30) && (xbounce == 0))
		begin
			xbounce <= 1;
			out_score <= out_score + 1;
		end
		//if it is at the left hand side and strikes the left paddle
		else if ((y_location + 15 > (lpad)) && (y_location < (lpad + 85)) && (x_location == 10) && (xbounce == 1))
		begin
			xbounce <= 0;
			out_score <= out_score + 1;
		end
		//if it hits the right hand side
		else if (x_location == 620-30)
		begin
			x_location <= 20;
			out_score <= 0;
		end
		//if it hits the left hand side
		else if (x_location == 0)
		begin
			x_location <= (605 - 30);
			out_score <= 0;
		end		
		//if not at the right hand side and moving right, move right
		if ((x_location < 620 - 30) && (xbounce == 0)) x_location <= x_location + 1;
		//if it is not at the left hand side and is moving left, move left
		else if ((x_location > 0) && (xbounce == 1)) x_location <= x_location - 1;
		
		if ((y_location < 480 - 30) && (ybounce == 0)) y_location <= y_location + 1;
		else if (ybounce == 0) ybounce <=1;
		else if (y_location > 0) y_location <= y_location - 1;
		else ybounce <= 0;
	end
endmodule

module movepaddle(
	input up,
	input down,
	input clk,
	output reg [9:0] paddlepos
	);
	
	always @(posedge clk)
	begin
		if ((paddlepos > 0) && !up) paddlepos <= paddlepos -1;
		else if ((paddlepos < 480-100) && !down) paddlepos <= paddlepos +1;
	end
endmodule
		
