// Animation

module animation
	(
		CLOCK_50,						//	On Board 50 MHz
		KEY,							//	Push Button[3:0]
		LED,
		SW,
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
	input SW;
	input	[3:0]	KEY;					//	Button[3:0]
	output [2:0] LED;
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
	parameter IMAGE_FILE = "aa.mif"; 
	assign black = 3'b000;
	assign gnd = 1'b0;
	lpm_ram_dq my_ram(
		.inclock(CLOCK_50), 
		.outclock(CLOCK_50), 
		.data(black),
		.address(mem_address), 
		.we(gnd), 
		.q(memory) );
		
	defparam my_ram.LPM_FILE = IMAGE_FILE;
	defparam my_ram.LPM_WIDTH = 3;
	defparam my_ram.LPM_WIDTHAD = 8;
	defparam my_ram.LPM_INDATA = "REGISTERED";
	defparam my_ram.LPM_ADDRESS_CONTROL = "REGISTERED";
	defparam my_ram.LPM_OUTDATA = "REGISTERED";

	wire writeEn = 1;
	wire [2:0] memory;
	wire [2:0] color = ( picture == 1 && SW == 1) ? memory : black;
	wire done;
	wire picture;
	wire plt = SW;
	wire blk = KEY[2];
	reg [7:0] x;
	reg [6:0] y;
	reg [7:0] x_origin = 8'h15;
	reg [7:0] y_origin = 8'h15;
	reg [31:0] counter = 0;

	assign done = (x == 8'd159) & (y == 7'd119);
	assign picture = (x_origin+2 <= x) && (x < x_origin + 16) && (y_origin <= y) && (y < y_origin + 16);
	
	always @(posedge CLOCK_50) begin
		if(!resetn) begin
			x <= 0;
			y <= 0;
			counter <= 0;
		end else begin
			counter <= counter + 1;
			if (counter == 32'd222000) begin
				counter <= 0;
				y_origin <= y_origin + 1;
				if(y_origin == 7'd104) begin
					y_origin <= 0;
				end
			end
			
			x <= x + 1;
			if (x == 8'd159) begin
				x <= 0;
				y <= y + 1;
				if(y == 7'd119) begin
					y <= 0;
					
				end
			end
				
		end 

	end
	
	wire [7:0] mem_address = (x_origin <= x) && (x < x_origin + 16) && (y_origin <= y) && (y < y_origin + 16) ? (x-x_origin) + 16 * (y - y_origin) : 8'd0; 
	
	assign LED = counter[2:0];
	
	
endmodule