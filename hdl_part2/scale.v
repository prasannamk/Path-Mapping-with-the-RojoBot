module scale(
	input  [11:0]	pixel_row,
	input  [11:0]	pixel_column,
	output [13:0] 	vid_addr

);

reg [6:0]row_vid;
reg [6:0]col_vid;

assign vid_addr = col_vid + row_vid*128 ;

always@(*) begin

	col_vid = pixel_column/8;
	row_vid = pixel_row/6;

end

endmodule