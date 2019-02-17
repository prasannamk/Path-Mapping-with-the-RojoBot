module colorizer(
	input [0:0]video_on,
	input [1:0]world_pixel,
	input [1:0]icon,
	output reg [3:0] vga_red,
	output reg [3:0] vga_blue,
	output reg [3:0] vga_green
);

always@(*) begin

	if (video_on == 1'b0) begin
	
		vga_red = 4'b0;
		vga_blue = 4'b0;
		vga_green = 4'b0;
	end
	else begin
		case (icon) 
			2'b00: begin
					case (world_pixel) 
						2'b00: begin
							vga_red = 4'b1111;
							vga_blue = 4'b1111;
							vga_green = 4'b1111;
							end
						2'b01:begin
							vga_red = 4'b0000;
							vga_blue = 4'b0000;
							vga_green = 4'b0000;
						end
						2'b10: begin
							vga_red = 4'b1111;
							vga_blue = 4'b0000;
							vga_green = 4'b0000;
							end
						2'b11:begin
							vga_red = 4'b0000 ;
							vga_blue = 4'b0000;
							vga_green = 4'b0000;
							end
					endcase
			end
			2'b01: begin
					vga_red = 4'b1111;
					vga_blue = 4'b1111;
					vga_green = 4'b0;
			end
			2'b10:begin
					vga_red = 4'b0;
					vga_blue = 4'b1111;
					vga_green = 4'b1111;
			end
			2'b11: begin
					vga_red = 4'b0;
					vga_blue = 4'b0;
					vga_green = 4'b1100;
		          end
		endcase
		
    end
end
endmodule