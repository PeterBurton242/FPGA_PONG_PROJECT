module VGA_video_top(CLOCK_50, 
                VGA_R, VGA_G, VGA_B, VGA_HS,
					 VGA_VS, LEDG, ORG_BUTTON, HEX0_D,
					 HEX1_D, HEX2_D, HEX3_D);

input		wire			CLOCK_50;

output 	wire	[0:0]	LEDG;
input		wire	[2:0] ORG_BUTTON;
output	wire	[6:0] HEX0_D;			//7 seg digit 0
output	wire	[6:0] HEX1_D;			//7 seg digit 1
output	wire	[6:0] HEX2_D;			//7 seg digit 2
output	wire	[6:0] HEX3_D;			//7 seg digit 3

output	wire	[3:0]		VGA_R;		//Output Red
output	wire	[3:0]		VGA_G;		//Output Green
output	wire	[3:0]		VGA_B;		//Output Blue

output	wire	[0:0]		VGA_HS;		//Horizontal Sync
output	wire	[0:0]		VGA_VS;		//Vertical Sync

wire			[9:0]		X_pix;			//Location in X of the driver
wire			[9:0]		Y_pix;			//Location in Y of the driver

wire			[0:0]		H_visible;		//output by VGA module to tell
wire			[0:0]		V_visible;		//if the current pixel is on screen

wire			[0:0]		pixel_clk;		//Pixel clock. Every clock a pixel is being drawn. 
wire			[9:0]		pixel_cnt;		//How many pixels have been output.

reg			[11:0]	pixel_color;	//12 Bits representing color of pixel, 4 bits for R, G, and B
												//4 bits for Blue are in most significant position, Red in least

reg gameclock;
wire 			[9:0] 	ballx;			//ball position
wire 			[9:0] 	bally;

wire 			[9:0] 	leftpaddle;		//left paddle position
wire 			[9:0] 	rightpaddle;

reg 			[13:0]	curr_score;		//score in binary
reg 			[15:0]	bcd_score;		//score in BCD
										
wire 						isball;			//wires that are used to pass
wire 						islpaddle;		//positions of objects to 
wire 						isrpaddle;		//VGA module

clockdivider gameclock1(
	.in_clk(CLOCK_50),
	.out_clk(gameclock)
	);

moveball movetheball(
	.clk(gameclock), 
	.lpad(leftpaddle),
	.rpad(rightpaddle),
	.x_location(ballx), 
	.y_location(bally),
	.out_score(curr_score),
	);

makebox makeball(
	.x_pix(X_pix),
	.y_pix(Y_pix),
	.width(10'd30),
	.height(10'd30),
	.x_loc(ballx),
	.y_loc(bally),
	.box(isball)
	);

BCD_CONV convertscore(
	.bin(curr_score),
	.BCD(bcd_score),
	.CLK(gameclock)
	);
	
BCD_Display ones (
	.d(bcd_score[3:0]),
	.seg(HEX0_D)
	);
	
BCD_Display tens (
	.d(bcd_score[7:4]),
	.seg(HEX1_D)
	);
	
BCD_Display hunds (
	.d(bcd_score[11:8]),
	.seg(HEX2_D)
	);
	
BCD_Display thousands (
	.d(bcd_score[15:12]),
	.seg(HEX3_D)
	);	
	
movepaddle moveleft(
	.up(ORG_BUTTON[0]),
	.down(ORG_BUTTON[2]),
	.clk(gameclock),
	.paddlepos(leftpaddle)
	);

movepaddle moveright(
	.up(ORG_BUTTON[2]),
	.down(ORG_BUTTON[0]),
	.clk(gameclock),
	.paddlepos(rightpaddle)
	);
	
makebox makeleftpaddle(
	.x_pix(X_pix),
	.y_pix(Y_pix),
	.width(10'd10),
	.height(10'd100),
	.x_loc(0),
	.y_loc(leftpaddle),
	.box(islpaddle)
	);
makebox makerightpaddle(
	.x_pix(X_pix),
	.y_pix(Y_pix),
	.width(10'd10),
	.height(10'd100),
	.x_loc(605),
	.y_loc(rightpaddle),
	.box(isrpaddle)
	);
		
							
always @(posedge pixel_clk)
	begin
		if(isball || islpaddle || isrpaddle) pixel_color <= 12'b1111_1111_1111;
		else pixel_color <= 12'b0001_0001_0001;
	end
	
		//Pass pins and current pixel values to display driver
		DE0_VGA VGA_Driver
		(
			.clk_50(CLOCK_50),
			.pixel_color(pixel_color),
			.VGA_BUS_R(VGA_R), 
			.VGA_BUS_G(VGA_G), 
			.VGA_BUS_B(VGA_B), 
			.VGA_HS(VGA_HS), 
			.VGA_VS(VGA_VS), 
			.X_pix(X_pix), 
			.Y_pix(Y_pix), 
			.H_visible(H_visible),
			.V_visible(V_visible), 
			.pixel_clk(pixel_clk),
			.pixel_cnt(pixel_cnt)
		);

endmodule

module makebox(
	input [9:0] x_pix,
	input [9:0] y_pix,
	input [9:0] width,
	input [9:0] height,
	input [9:0] x_loc,
	input [9:0] y_loc,
	output wire box
	);
	
	assign box = ((x_pix > x_loc) && (x_pix < (x_loc + width)) && (y_pix > y_loc) && (y_pix < (y_loc + height))) ? 1 : 0;
	
endmodule



