// Scaler for the Nexys4 DDR board
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
// This module scales the 128x128 world of the map to the 1024x768 that is needed to drive the 
// VGA monitor.
//
///////////////////////////////////////////////////////////////////////////////////
module scale(
	input  [11:0]	pixel_row,
	input  [11:0]	pixel_column,
	output [13:0] 	vid_addr

);

reg [6:0]row_vid; // This is the variable that will hold the row value 
reg [6:0]col_vid; // This is the variable that will hold the column value 

// calculate the vid_addr to send ahead
assign vid_addr = col_vid + row_vid*128 ;

always@(*) begin

	col_vid = pixel_column/8;	// We use a simple divide by 8 statement that allows verilog to optimize the way the addition is being performed
	row_vid = pixel_row/6;		// Vivado ihherently takes care of these kind of divisions, else we'll have to create a module for dividing by six.

end

endmodule