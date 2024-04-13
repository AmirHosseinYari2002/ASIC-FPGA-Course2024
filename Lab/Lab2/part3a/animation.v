module animation
	(
		CLOCK_50,						//	On Board 50 MHz
		KEY,
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
	input	[3:0] 	KEY;					//	Button[0:0]
	input	[16:0] 	SW;						//	Button[0:0]
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	

	
	// Create the color, x, y and writeEn wires that are inputs to the controller.




	wire 	[7:0]	screen_X;
	wire	[6:0]	screen_Y;
	wire	Plot;
	wire	Blank;
	
	reg [7:0]counter_X;
	reg [6:0]counter_Y;
	reg [2:0] color;
	reg writeEn;
	
	wire resetn;
	assign resetn = KEY[1];
	assign screen_X = SW[7:0];
	assign screen_Y = SW[14:8];
	assign Blank = SW[15];
	assign Plot = SW[16];
	
	reg [2:0]state = 3'bxxx;
	parameter addressing_mem = 3'b000;
	parameter draw = 3'b001;
	parameter change_cordinate = 3'b010;
	parameter done = 3'b011;


	//*****************************************************************
	
	always @(posedge CLOCK_50 or negedge resetn)
	begin
		if(!resetn)
		begin
			counter_X <= 8'b0;
			counter_Y <= 7'b0;
			state <= addressing_mem;
			writeEn <= 0;
		end
		else if(Plot)
		begin
			case(state)
				addressing_mem:
				begin
					mem_address <= counter_Y * 16 + counter_X;
					state <= draw;
				end
				draw:
				begin
					if(Blank)
						color <= 3'b000;
					else
						color <= mem_out;
					writeEn <= 1;
					state <= change_cordinate;
				end
				change_cordinate:
				begin
					if(counter_Y <= 16)
					begin
						counter_X <= counter_X < 16 ? counter_X + 1 : 8'b0;
						counter_Y <= counter_X == 16 ? counter_Y + 1 : counter_Y;
						state <= addressing_mem;
					end
					else
						state <= done;
					writeEn <= 0;
				end
				done:
				begin
					counter_X <= 8'b0;
					counter_Y <= 7'b0;
					state <= addressing_mem;
					writeEn <= 0;
				end
			endcase
		
		end
	end
	
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(color),
			.x(screen_X + counter_X),
			.y(screen_Y + counter_Y),
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
		//*****************************************************************
	//reading from memory
	parameter IMAGE_FILE = "image.mif";
	wire gnd;
	wire [2:0] black_color;
	reg [7:0]mem_address;
	wire [2:0]mem_out;
	assign black_color = 3'b000;
	assign gnd = 1'b0;
	lpm_ram_dq my_ram(.inclock(CLOCK_50), .outclock(CLOCK_50), .data(black_color),
								.address(mem_address), .we(gnd), .q(mem_out) );
	defparam my_ram.LPM_FILE = IMAGE_FILE;
	defparam my_ram.LPM_WIDTH = 3;
	//defparam my_ram.LPM_WIDTHAD = BITS_TO_ADDRESS_IMAGE + IMAGE_ID_BITS;
	defparam my_ram.LPM_WIDTHAD = 1;
	defparam my_ram.LPM_INDATA = "REGISTERED" ;
	defparam my_ram.LPM_ADDRESS_CONTROL = "REGISTERED";
	defparam my_ram.LPM_OUTDATA = "REGISTERED";
	
	//*****************************************************************
	
	// Put your code here. Your code should produce signals x,y,color and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.
	
	
endmodule