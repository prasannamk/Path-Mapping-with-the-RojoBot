// Icon module for the Nexys4 DDR board
//
//  
// Created By:	    Prasanna_Kulkarni and Atharva_Mahindarkar
// Last Modified:	19-February-2019 
//
// Revision History:
// -----------------
// Feb-2019   AM_PK		Created this module for the NexysDDR4 Starter Board
//
//
// Description:
// ------------
// This module is how we superimpose the the icon onto the world map.
// We use eight .COE files inside eight block RAMs to have eight different 
// icon images for each possible orientation of the rojobot.
// 
///////////////////////////////////////////////////////////////////////////

module icon(
	input clk,
	input [11:0]	pixel_column, pixel_row,
	input [7:0]		LocX_reg, LocY_reg,
	input [7:0]	BotInfo_reg,
	output reg[1:0]		icon
);

wire [7:0]	icon_wire_0, icon_wire_1,icon_wire_2, icon_wire_3,icon_wire_4,
			icon_wire_5,icon_wire_6,icon_wire_7 ;

wire [7:0]    pixel_column_reg,	pixel_row_reg ;

wire [7:0]	  iconize_addr;

reg  [7:0]     iconize_addr_x, iconize_addr_y; 


blk_mem_gen_0 iconize_0 (
  .clka(clk),    // input wire clka
  .addra(iconize_addr),  // input wire [9 : 0] addra
  .douta(icon_wire_0)  // output wire [15 : 0] douta
);

blk_mem_gen_1 iconize_1 (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(iconize_addr),  // input wire [9 : 0] addra
  .douta(icon_wire_1)  // output wire [15 : 0] douta
);

blk_mem_gen_2 iconize_2 (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(iconize_addr),  // input wire [9 : 0] addra
  .douta(icon_wire_2)  // output wire [15 : 0] douta
);

blk_mem_gen_3 iconize_3 (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(iconize_addr),  // input wire [9 : 0] addra
  .douta(icon_wire_3)  // output wire [15 : 0] douta
);

blk_mem_gen_4 iconize_4 (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(iconize_addr),  // input wire [9 : 0] addra
  .douta(icon_wire_4)  // output wire [15 : 0] douta
);

blk_mem_gen_5 iconize_5 (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(iconize_addr),  // input wire [9 : 0] addra
  .douta(icon_wire_5)  // output wire [15 : 0] douta
);

blk_mem_gen_6 iconize_6 (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(iconize_addr),  // input wire [9 : 0] addra
  .douta(icon_wire_6)  // output wire [15 : 0] douta
);

blk_mem_gen_7 iconize_7 (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(iconize_addr),  // input wire [9 : 0] addra
  .douta(icon_wire_7)  // output wire [15 : 0] douta
);


// scale to map level
assign    pixel_column_reg = pixel_column/8;
assign    pixel_row_reg = pixel_row/6;

// Generation of the addresses for the Block RAM.
assign iconize_addr = iconize_addr_y * 4 + iconize_addr_x;


always@(*)begin
  // case for generating address row/ column for the two port RAMs  
	case (pixel_column_reg)
		LocX_reg:  // Value of the column address if The pixel column is equal 
				   // to the LocX_reg of the rojobot
			iconize_addr_x = 2'b00;
		
		LocX_reg+1: // Value of the column address if The pixel column is equal 
				    // to the LocX_reg+1 of the rojobot
			iconize_addr_x = 2'b01;
			
		LocX_reg+2: // Value of the column address if The pixel column is equal 
				    // to the LocX_reg+2 of the rojobot
			iconize_addr_x = 2'b10;
		
		LocX_reg+3: // Value of the column address if The pixel column is equal 
				    // to the LocX_reg of+3 the rojobot
			iconize_addr_x = 2'b11;
		default:
                 iconize_addr_x = 2'b00;
		
    endcase
	
	
	case (pixel_row_reg)
		LocY_reg:  // Value of the row address if the pixel row is equal 
				   // to the LocY_reg of the rojobot
			iconize_addr_y = 2'b00;
		
		LocY_reg+1:// Value of the row address if the pixel row is equal 
				   // to the LocY_reg+1 of the rojobot
			iconize_addr_y = 2'b01;
			
		LocY_reg+2:// Value of the row address if the pixel row is equal 
				   // to the LocY_reg+2 of the rojobot
			iconize_addr_y = 2'b10;
		
		LocY_reg+3:// Value of the row address if the pixel row is equal 
				   // to the LocY_reg+3 of the rojobot
			iconize_addr_y = 2'b11;
		default:
		     iconize_addr_y = 2'b00;
    endcase
    // if the location is at the icon --> write icon colour based on .COE file
    if (pixel_column_reg >= LocX_reg
        && pixel_row_reg >= LocY_reg
        && pixel_column_reg < (LocX_reg+4)
        && pixel_row_reg < (LocY_reg+4)) begin
                 case (BotInfo_reg[2:0]) // This switch case controls the image of the icon
										 // based upon the orientation of the rojobot.
                    
                        3'b000:
                            icon = icon_wire_0; // icon block ram data_out to be used if orientation is 0 degree.
                        3'b001:
                            icon = icon_wire_1; // icon block ram data_out to be used if orientation is 45 degree.
                        3'b010:
                            icon = icon_wire_2; // icon block ram data_out to be used if orientation is 90 degree.
                        3'b011:
                            icon = icon_wire_3; // icon block ram data_out to be used if orientation is 135 degree.
                        3'b100:
                            icon= icon_wire_4;  // icon block ram data_out to be used if orientation is 180 degree.
                        3'b101:
                            icon= icon_wire_5;  // icon block ram data_out to be used if orientation is 225 degree.
                        3'b110:
                            icon= icon_wire_6;  // icon block ram data_out to be used if orientation is 270 degree.
                        3'b111:
                            icon= icon_wire_7;  // icon block ram data_out to be used if orientation is 315 degree.
                        default:
                            icon= icon_wire_0;  // default value. The reason to have this is that not having a default value 
												// leads to the synthesis of a latch. If there's a latch in the design for the icon
												// we'll see the icon leaving "afterimages".
                    endcase
                end
	else begin
	   icon = 2'b00; // If we're out of the bounds of the icon, we'll need to send a value corresponding to the 
					 // transparent pixels 
    end
end

endmodule