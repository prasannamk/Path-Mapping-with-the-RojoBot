module icon(
	input [11:0]	pixel_column, pixel_row,
	input [7:0]		LocX_reg, LocY_reg,
	input [7:0]	BotInfo_reg,
	output reg[1:0]		icon
);



reg [7:0]	icon_reg_0,icon_reg_1,icon_reg_3,icon_reg_4,
			icon_reg_5,icon_reg_6,icon_reg_7;

wire [7:0]      pixel_column_reg,	pixel_row_reg;

assign    pixel_column_reg = pixel_column/8;
assign    pixel_row_reg = pixel_row/6;

always@(*)begin


    if (pixel_column_reg >= LocX_reg
        && pixel_row_reg >= LocY_reg
        && pixel_column_reg < (LocX_reg+4)
        && pixel_row_reg < (LocY_reg+4)) begin

	/*if (pixel_column_reg >= (LocX_reg)
		&& pixel_column_reg < (LocX_reg+3'b100)
		&& pixel_row_reg >= (LocY_reg)
		&& pixel_row_reg < (LocY_reg+3'b100)) begin
*/
                 case (BotInfo_reg[2:0])
                    
                        3'b000:
                            icon = 2'b01; 
                        3'b001:
                            icon = 2'b01;
                        3'b010:
                            icon = 2'b01;
                        3'b011:
                            icon = 2'b01;
                        3'b100:
                            icon= 2'b01;
                        3'b101:
                            icon= 2'b01;
                        3'b110:
                            icon= 2'b01;
                        3'b111:
                            icon= 2'b01;
                        default:
                            icon= 2'b01;
                    endcase
              ;
                end
	else begin
	   icon = 2'b00;
    end
end

endmodule