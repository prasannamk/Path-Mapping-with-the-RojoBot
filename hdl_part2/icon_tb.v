module icon_tb;

	wire	[11:0]	pixel_column, pixel_row;
	wire	[7:0]		LocX_reg, LocY_reg;
	wire	[7:0]	BotInfo_reg;
	wire	[1:0]		icon;
	
icon(
	 	pixel_column, pixel_row,
	 	LocX_reg, LocY_reg,
	 	BotInfo_reg,
		icon
);


LocX_reg = 64;
LocY_reg = 64;

for (int i = 0 , i< 1023, i++ ) begin

	#5 pixel_column = i;
	
end

for (int j = 0 , j< 785, j++ ) begin

	#5 pixel_row = j;
	
end
	
endmodule