// Animation

// KEY[0] -> resetn
// KEY[1] -> plot
// KEY[2] -> blank

module animation
	(
		CLOCK_50,						//	On Board 50 MHz
		KEY,							//	Push Button[3:0]
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input	[3:0]	KEY;					//	Button[3:0]
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the color, x, y and writeEn wires that are inputs to the controller.

	// Create an Instance of a VGA controller - there can be only one!	
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(color),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK),
			.VGA_SYNC(VGA_SYNC),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "";
			
	// Put your code here. Your code should produce signals x,y,color and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	parameter IMAGE_FILE = "animation.mif"; 
	assign black_color = 3'b000;
	assign gnd = 1'b0;
	lpm_ram_dq my_ram(
		.inclock(CLOCK_50), 
		.outclock(CLOCK_50), 
		.data(black_color),
		.address(mem_address), 
		.we(gnd), 
		.q(mem_out) );
		
	defparam my_ram.LPM_FILE = IMAGE_FILE;
	defparam my_ram.LPM_WIDTH = 3;
	defparam my_ram.LPM_WIDTHAD = BITS_TO_ADDRESS_IMAGE + IMAGE_ID_BITS;
	defparam my_ram.LPM_INDATA = "REGISTERED";
	defparam my_ram.LPM_ADDRESS_CONTROL = "REGISTERED";
	defparam my_ram.LPM_OUTDATA = "REGISTERED";

	
	wire [2:0] color = (plt == 1 & pict == 1) ? mem_out : black_color;
	reg [7:0] x;
	reg [6:0] y;
	wire writeEn = 1;	
	
	wire done,pict;
	assign done = (x == 8'd159) & (y == 7'd119);
	assign pict = (xTopLeft <= x) & (x < xTopLeft + 16) & (yTopLeft <= y) & (y < yTopLeft + 16);
	
	reg [7:0] xTopLeft;
	reg [6:0] yTopLeft;
	
	wire plt = KEY[1];
	wire blk = KEY[2];
	
	wire dx,dy;
	assign dx = 1;
	assign dy = 1;
	
	always @(posedge CLOCK_50) begin
		if(!resetn) begin
			x <= 0;
			y <= 0;
			xTopLeft <= 0;
			yTopLeft <= 0;
		
		end else if(!done) begin
			x <= x + 1;
			if (x == 8'd159) begin
				x <= 0;
				y <= y + 1;
			end
		end /*
		else if(done) begin
			xTopLeft <= xTopLeft + dx;
			yTopLeft <= yTopLeft + dy;
			if(xTopLeft+dx+16 >= 8'd159) begin
				xTopLeft <= xTopLeft - dx;
			end
			//if(xTopLeft <= 8'd1) begin
			//	xTopLeft <= xTopLeft + dx;			
			//end
			if(yTopLeft+dy+16 >= 7'd119) begin
				yTopLeft <= yTopLeft - dy;
			end
			//if(yTopLeft <= 7'd1) begin
			//	yTopLeft <= yTopLeft + dy;
			//end
		
		
		end
		*/
		
	
	
	
	
	end
	
	
	
	
	
	
	
	
	
	
	
endmodule