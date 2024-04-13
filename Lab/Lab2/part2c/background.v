// Background image display

module background
	(
		CLOCK_50,						//	On Board 50 MHz
		KEY,
		SW,							//	Push Button[0:0]
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK,						//	VGA BLANK
		VGA_SYNC,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B	  						//	VGA Blue[9:0]
	);

	input	CLOCK_50;				//	50 MHz
	input	[3:0] KEY;				//	Button[0:0]
	input	[3:0] SW;				//	Button[0:0]
	output	VGA_CLK;   				//	VGA Clock
	output	VGA_HS;					//	VGA H_SYNC
	output	VGA_VS;					//	VGA V_SYNC
	output	VGA_BLANK;				//	VGA BLANK
	output	VGA_SYNC;				//	VGA SYNC
	output	[9:0] VGA_R;   			//	VGA Red[9:0]
	output	[9:0] VGA_G;	 		//	VGA Green[9:0]
	output	[9:0] VGA_B;   			//	VGA Blue[9:0]
	
	wire resetn;
	reg  plot = 0;
	reg [2:0] color;
	reg [7:0] x;
	reg [6:0] y;
	
	wire left,right,up,down;
	reg [3:0]state;
	
	parameter height = 17;
	parameter width = 17;
	reg [7:0]counter_X;
	reg [7:0]counter_Y;
	reg [7:0]x_first;
	reg [6:0]y_first;
	
	parameter raiduce = 8;
	reg [7:0]x_center;
	reg [6:0]y_center;
	
	reg [3:0]dir;
	reg [14:0]counter_erase;
	reg asshole = 0;
	
	parameter draw = 4'b0000;
	parameter Wait = 4'b0001;
	parameter up_s = 4'b0010;
	parameter down_s = 4'b0011;
	parameter left_s = 4'b0100;
	parameter right_s = 4'b0101;
	parameter pre_draw = 4'b0110;
	parameter erase = 4'b0111;
	parameter pre_erase = 4'b1000;
	
	assign resetn = SW[0];

	// Further assignments go here...
	assign left = !KEY[3];
	assign right = !KEY[2];
	assign up = !KEY[1];
	assign down = SW[1];
	
	//
	reg [25:0] accum = 0;
	wire pps ;
	assign pps =(accum == 0);
	
	always @(posedge CLOCK_50)
	begin
		accum <= (pps ? 500 : accum) - 1;
		if(~resetn)
		begin
			state <= draw;
			counter_X <= 0;
			counter_Y <= 0;
			x_first <= 50;
			y_first <= 50;
			x_center <= 50 + 8;
			y_center <= 50 + 8;
			plot <= 0;
			color <= 3'b011;
		end
		else if(pps)
		begin
		//////	
		case(state)
			erase:
			begin
				if (counter_Y < height )
				begin
					counter_X <= (counter_X < width) ? counter_X+1 : 0 ;
					counter_Y <= (counter_X < width) ? counter_Y : counter_Y + 1;
					plot  <= ((counter_X + x_first - x_center) * (counter_X + x_first - x_center) + (counter_Y + y_first - y_center) * (counter_Y + y_first - y_center)) < raiduce * raiduce ? 1 : 0 ;
					state <= erase;
				end
				else
				begin
					plot <= 0;
					counter_X <= 0;
					counter_Y <= 0;
					case (dir)
						up_s: state <= up_s;
						down_s: state <= down_s;
						right_s: state <= right_s;
						left_s: state <= left_s;
					endcase
				end

			end
			
			draw:
			begin
				if (counter_Y < height)
				begin
					counter_X <= (counter_X < width) ? counter_X+1 : 0 ;
					counter_Y <= (counter_X < width) ? counter_Y : counter_Y + 1;
					plot  <= ((counter_X + x_first - x_center) * (counter_X + x_first - x_center) + (counter_Y + y_first - y_center) * (counter_Y + y_first - y_center)) < raiduce * raiduce ? 1 : 0 ;
					state <= draw;
				end
				else 
				begin
					plot <= 0;
					counter_X <= 0;
					counter_Y <= 0;
					state <= Wait;
				end

				end
			up_s:
			begin
				y_first <= y_first - 1;
				y_center <= y_center -1;
				state <= pre_draw;
			end
			down_s:
			begin
				y_first <= y_first + 1;
				y_center <= y_center +1;
				state <= pre_draw;
			end
			left_s:
			begin
				x_first <= x_first - 1;
				x_center <= x_center -1;
				state <= pre_draw;
			end
			right_s:
			begin
				x_first <= x_first + 1;
				x_center <= x_center + 1;
				state <= pre_draw;
			end
			pre_draw:
			begin
				counter_X <= 0;
				counter_Y <= 0;
				color <= 3'b011;
				state <= draw;
			end
			pre_erase:
			begin
				counter_X <= 0;
				counter_Y <= 0;
				color <= 3'b000;
				state <= erase;
			end
			Wait:
				if(up && y_first > 0)
				begin
					state <= pre_erase;
					dir <= up_s;
				end
				else if(down && y_first + height < 120)
				begin
					state <= pre_erase;
					dir <= down_s;
				end
				else if(right && x_first + width < 160)
				begin
					state <= pre_erase;
					dir <= right_s;
				end
				else if(left && x_first > 0)
				begin	
					state <= pre_erase;
					dir <= left_s;
				end
			default: state <= Wait;
		endcase
		//////
		end
	end
	
	
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(color),
			.x(x_first+counter_X),
			.y(y_first+counter_Y),
			.plot(plot),
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
		
endmodule
