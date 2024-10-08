`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/25 09:12:16
// Design Name: 
// Module Name: ram_read_write
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ram_read_write
    (
	 input              clk,
	 input              rst_n,
	 
     input      [31:0]  din,	 
	 output reg [31:0]  dout,
	 output reg         en,
	 output reg [3:0]   we,
	 output             rst,
	 output reg [31:0]  addr,
	 
	 input              start,
	 input      [31:0]  init_data,
	 output reg         start_clr,
	 output reg         write_end,
	 input      [31:0]  len,
	 input      [31:0]  start_addr
    );


assign rst = 1'b0 ;
	
localparam IDLE      = 3'd0 ;
localparam READ_RAM  = 3'd1 ;
localparam READ_END  = 3'd2 ;
localparam WRITE_RAM = 3'd3 ;
localparam WRITE_END = 3'd4 ;

reg [2:0] state ;
reg [31:0] len_tmp ;
reg [31:0] start_addr_tmp ;
reg [15:0] index;
reg [15:0] mem[0:255];
reg [3:0]ad = 4;
reg [9:0] counter;
always @(*)
    begin
        case(init_data)
            1: ad = 4;
            2: ad = 8;
            4: ad = 16;
            8: ad = 32;
            default : ad = 4;
        endcase
    end
//write part	
always @(posedge clk or negedge rst_n)
begin
  if (~rst_n)
  begin
    state      <= IDLE  ;
	dout       <= 32'd0 ;
	en         <= 1'b0  ;
	we         <= 4'd0  ;
	addr       <= 32'd0 ;
	write_end  <= 1'b0  ;
	start_clr  <= 1'b0  ;
	len_tmp    <= 32'd0 ;
	start_addr_tmp <= 32'd0 ;
	
  end
	
  else
  begin
    case(state)
	IDLE            : begin
			            if (start)
						begin
			              state <= READ_RAM     ;
						  addr  <= start_addr   ;
						  start_addr_tmp <= start_addr ;
						  len_tmp <= len ;
						  dout <= init_data ;
						  en    <= 1'b1 ;
						  start_clr <= 1'b1 ;
						end			  
				        write_end <= 1'b0 ;
				        counter <= 0;
			          end

    
    READ_RAM        : begin
	                    if ((addr - start_addr_tmp) == len_tmp - 4)
						begin
						  state <= READ_END ;
						  en    <= 1'b0     ;
						end
						else
						begin
						  addr <= addr + ad ;
						end
						start_clr <= 1'b0 ;
						mem[counter] <= din;
						counter <= counter + 1;
					  end
					  
    READ_END        : begin
	                    addr  <= start_addr_tmp ;
	                    en <= 1'b1 ;
                        we <= 4'hf ;
					    state <= WRITE_RAM  ;
					    index <= 0;					    
					  end
    
	WRITE_RAM       : begin
//	                    if ((addr - start_addr_tmp) == len_tmp - 4)
                        if(index == counter)
						begin
						  state <= WRITE_END ;
						  dout  <= 32'd0 ;
						  en    <= 1'b0  ;
						  we    <= 4'd0  ;
						end
						else
						begin
						addr <= addr + 32'd4 ;
						dout[15:0] <= mem[index];
						index <= index + 1;
						end
					  end
					  
	WRITE_END       : begin
	                    addr <= 32'd0 ;
						write_end <= 1'b1 ;
					    state <= IDLE ;			
					    index <= 0;		    
					  end	
	default         : state <= IDLE ;
	endcase
  end
end	
	
endmodule
