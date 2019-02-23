// Colorizer for the Nexys4 DDR board
//
//  
// Created By:	    Prasanna_Kulkarni and Atharva_Mahindarkar
// Last Modified:	24-January-2019 
//
// Revision History:
// -----------------
// Feb-2019   AM_PK		Created this module for the NexysDDR4 Starter Board
//
//
// Description:
// ------------
// This module generates a VGA_value (R, G) to write onto the screen.
// It also takes into consideration the location of the icon and then
// Super imposes the icon onto the world.
// 
///////////////////////////////////////////////////////////////////////////
module colorizer(
	input [0:0]video_on,
	input [1:0]world_pixel,
	input [1:0]icon,
	output reg [3:0] vga_red,
	output reg [3:0] vga_blue,
	output reg [3:0] vga_green
);

always@(*) begin
	// If video on if false then black out the screen.
	// This snippet is vital for the refresh functionality of the screen
	if (video_on == 1'b0) begin
	
		vga_red = 4'b0;
		vga_blue = 4'b0;
		vga_green = 4'b0;
	end
	else begin
		// case for icon and world pixel colours, if you want different colours make changes here.
		
		case (icon) 
			2'b00: begin // When the is transperent we have to show the world. 
						// ie:- when the icon doesn't exist the world has to be printed normally
						
					case (world_pixel) // The world is "painted" using three colours.
									   // This leads to a 2 bit combination where the final combination is reserved.
									   
						2'b00: begin // This is the combination used for the black colour.
						
							vga_red = 4'b1111; 	// VGA_value for red
							vga_blue = 4'b1111;	// VGA_value for blue
							vga_green = 4'b1111;// VGA_value for green
							end
							
						2'b01:begin // This is the combination used for the transperent pixels.
						
							vga_red = 4'b0000; 	// VGA_value for red
							vga_blue = 4'b0000;	// VGA_value for blue
							vga_green = 4'b0000;// VGA_value for green
						end
						
						2'b10: begin //  This is the combination used for the red colour.
						
							vga_red = 4'b1111;  // VGA_value for red
							vga_blue = 4'b0000;	// VGA_value for blue
							vga_green = 4'b0000;// VGA_value for green
							end
						
						2'b11:begin // This is the combination that is reserved in case of further use.
						
							vga_red = 4'b0000 ;	// VGA_value for red
							vga_blue = 4'b0000;	// VGA_value for blue
							vga_green = 4'b0000;// VGA_value for green
							end
					endcase
			end
			
			2'b01: begin
					vga_red = 4'b1111;	// VGA_value for red
					vga_blue = 4'b1111;	// VGA_value for blue
					vga_green = 4'b0;	// VGA_value for green
			end
			
			2'b10:begin
					vga_red = 4'b0;		// VGA_value for red
					vga_blue = 4'b1111;	// VGA_value for blue
					vga_green = 4'b1111;// VGA_value for green
			end
			
			2'b11: begin
					vga_red = 4'b0;		// VGA_value for red
					vga_blue = 4'b0;	// VGA_value for blue
					vga_green = 4'b1100;// VGA_value for green
		          end
		endcase
		
    end
end
endmodule