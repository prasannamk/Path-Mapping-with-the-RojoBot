module icon(
	input clk,
	input [11:0]	pixel_column, pixel_row,
	input [7:0]		LocX_reg, LocY_reg,
	input [7:0]	BotInfo_reg,
	output reg[1:0]		icon
);

wire [7:0]	icon_reg_1,icon_reg_2, icon_reg_3,icon_reg_4,
			icon_reg_5,icon_reg_6,icon_reg_7 ;

wire [7:0]    pixel_column_reg,	pixel_row_reg, icon_reg_0;

wire [7:0]	  iconize_addr;

reg  [7:0]     iconize_addr_x, iconize_addr_y; 

/*blk_mem_gen_0 iconize_1 (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .wea(1'b1),      // input wire [0 : 0] wea
  .addra(iconize_addr),  // input wire [9 : 0] addra
  .dina(1'b0),    // input wire [15 : 0] dina
  .douta(icon_reg_0)  // output wire [15 : 0] douta
);*/

blk_mem_gen_0 iconize_0 (
  .clka(clk),    // input wire clka
  .addra(iconize_addr),  // input wire [9 : 0] addra
  .douta(icon_reg_0)  // output wire [15 : 0] douta
);

blk_mem_gen_1 iconize_1 (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(iconize_addr),  // input wire [9 : 0] addra
  .douta(icon_reg_1)  // output wire [15 : 0] douta
);

blk_mem_gen_2 iconize_2 (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(iconize_addr),  // input wire [9 : 0] addra
  .douta(icon_reg_2)  // output wire [15 : 0] douta
);

blk_mem_gen_3 iconize_3 (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(iconize_addr),  // input wire [9 : 0] addra
  .douta(icon_reg_3)  // output wire [15 : 0] douta
);

blk_mem_gen_4 iconize_4 (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(iconize_addr),  // input wire [9 : 0] addra
  .douta(icon_reg_4)  // output wire [15 : 0] douta
);

blk_mem_gen_5 iconize_5 (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(iconize_addr),  // input wire [9 : 0] addra
  .douta(icon_reg_5)  // output wire [15 : 0] douta
);

blk_mem_gen_6 iconize_6 (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(iconize_addr),  // input wire [9 : 0] addra
  .douta(icon_reg_6)  // output wire [15 : 0] douta
);

blk_mem_gen_7 iconize_7 (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(iconize_addr),  // input wire [9 : 0] addra
  .douta(icon_reg_7)  // output wire [15 : 0] douta
);



assign    pixel_column_reg = pixel_column/8;
assign    pixel_row_reg = pixel_row/6;

assign iconize_addr = iconize_addr_y * 4 + iconize_addr_x;


always@(*)begin
    
	case (pixel_column_reg)
		LocX_reg: 
			iconize_addr_x = 2'b00;
		
		LocX_reg+1:
			iconize_addr_x = 2'b01;
			
		LocX_reg+2:
			iconize_addr_x = 2'b10;
		
		LocX_reg+3:
			iconize_addr_x = 2'b11;
		default:
                 iconize_addr_x = 2'b00;
		
    endcase
	
	
	case (pixel_row_reg)
		LocY_reg:
			iconize_addr_y = 2'b00;
		
		LocY_reg+1:
			iconize_addr_y = 2'b01;
			
		LocY_reg+2:
			iconize_addr_y = 2'b10;
		
		LocY_reg+3:
			iconize_addr_y = 2'b11;
		default:
		     iconize_addr_y = 2'b00;
    endcase
	
    if (pixel_column_reg >= LocX_reg
        && pixel_row_reg >= LocY_reg
        && pixel_column_reg < (LocX_reg+4)
        && pixel_row_reg < (LocY_reg+4)) begin
                 case (BotInfo_reg[2:0])
                    
                        3'b000:
                            icon = icon_reg_0; 
                        3'b001:
                            icon = icon_reg_1;
                        3'b010:
                            icon = icon_reg_2;
                        3'b011:
                            icon = icon_reg_3;
                        3'b100:
                            icon= icon_reg_4;
                        3'b101:
                            icon= icon_reg_5;
                        3'b110:
                            icon= icon_reg_6;
                        3'b111:
                            icon= icon_reg_7;
                        default:
                            icon= icon_reg_0;
                    endcase
                end
	else begin
	   icon = 2'b00;
    end
end

endmodule