// mfp_nexys4_ddr.v
// January 1, 2017
//
// Instantiate the mipsfpga system and rename signals to
// match the GPIO, LEDs and switches on Digilent's (Xilinx)
// Nexys4 DDR board

// Outputs:
// 16 LEDs (IO_LED) 
// Inputs:
// 16 Slide switches (IO_Switch),
// 5 Pushbuttons (IO_PB): {BTNU, BTND, BTNL, BTNC, BTNR}
//

`include "mfp_ahb_const.vh"

module mfp_nexys4_ddr( 
                        input                   CLK100MHZ,
                        input                   CPU_RESETN,

                        input                   BTNU, BTND, BTNL, BTNC, BTNR, 
                        input  [`MFP_N_SW-1 :0] SW,
                        output [`MFP_N_LED-1:0] LED,
                        output 	   [7:0]	AN,
                        output              CA, CB, CC, CD, CE, CF, CG,
                        output              DP,
						output [3:0]        VGA_R,
						output [3:0]		VGA_G,
						output [3:0]		VGA_B,
						output 				VGA_HS, VGA_VS,
                        inout  [ 8:1] 		JB,
                        input               UART_TXD_IN);

  // Press btnCpuReset to reset the processor. 
        
  wire clk_out, clk_out2; 
  wire tck_in, tck;
  
  wire [7:0]	IO_BotCtrl;
  wire [31:0]	IO_BotInfo;
  wire [0:0]	IO_BotUpdt_Sync;
  wire [0:0]	IO_INT_ACK;
  wire [7:0]	MotCtl_in, LocX_reg, LocY_reg, Sensors_reg, BotInfo_reg, Bot_Config_reg, upd_sysregs;
  wire [1:0] 	world_pixel,worldmap_data, icon_pixel;
  wire [13:0]	vid_addr, worldmap_addr;
  wire [0:0] 	video_on; 
  wire [11:0]	pixel_column,pixel_row;
  
  
  
  assign IO_BotCtrl = MotCtl_in;
  assign IO_BotInfo = { LocX_reg, LocY_reg, Sensors_reg, BotInfo_reg};
 
    clk_wiz_0 clk_wiz_0
   (
    // Clock out ports
    .clk_out1(clk_out),     // output clk_out1
    .clk_out2(clk_out2),     // output clk_out2
   // Clock in ports
    .clk_in1(CLK100MHZ));
  
  IBUF IBUF1(.O(tck_in),.I(JB[4]));
  BUFG BUFG1(.O(tck), .I(tck_in));

  mfp_sys mfp_sys(
			        .SI_Reset_N(CPU_RESETN),
                    .SI_ClkIn(clk_out),
                    .HADDR(),
                    .HRDATA(),
                    .HWDATA(),
                    .HWRITE(),
					.HSIZE(),
                    .EJ_TRST_N_probe(JB[7]),
                    .EJ_TDI(JB[2]),
                    .EJ_TDO(JB[3]),
                    .EJ_TMS(JB[1]),
                    .EJ_TCK(tck),
                    .SI_ColdReset_N(JB[8]),
                    .EJ_DINT(1'b0),
                    .IO_AN(AN),
                    .IO_CA(CA), 
                    .IO_CB(CB), 
                    .IO_CC(CC), 
                    .IO_CD(CD), 
                    .IO_CE(CE), 
                    .IO_CF(CF), 
                    .IO_CG(CG),
                    .IO_DP(DP), 
					.IO_BotCtrl(IO_BotCtrl),
					.IO_BotInfo(IO_BotInfo),
					.IO_INT_ACK(IO_INT_ACK),
					.IO_BotUpdt_Sync(IO_BotUpdt_Sync),
                    .IO_Switch(SW),
                    .IO_PB({BTNU, BTND, BTNL, BTNC, BTNR}),
                    .IO_LED(LED),
                    .UART_RX(UART_TXD_IN));
					
  rojobot31_0 inst (
                      .MotCtl_in(MotCtl_in),            // input wire [7 : 0] MotCtl_in
                      .LocX_reg(LocX_reg),              // output wire [7 : 0] LocX_reg
                      .LocY_reg(LocY_reg),              // output wire [7 : 0] LocY_reg
                      .Sensors_reg(Sensors_reg),        // output wire [7 : 0] Sensors_reg
                      .BotInfo_reg(BotInfo_reg),        // output wire [7 : 0] BotInfo_reg
                      .worldmap_addr(worldmap_addr),    // output wire [13 : 0] worldmap_addr
                      .worldmap_data(worldmap_data),    // input wire [1 : 0] worldmap_data
                      .clk_in(clk_out2),                  // input wire clk_in
                      .reset(~CPU_RESETN),                    // input wire reset
                      .upd_sysregs(upd_sysregs),        // output wire upd_sysregs
                      .Bot_Config_reg(8'b0)  // input wire [7 : 0] Bot_Config_reg
                    ); 
					
   colorizer colorizer(
	.video_on(video_on),
	.world_pixel(world_pixel),
	.icon(icon_pixel),
	.vga_red(VGA_R), 
	.vga_green(VGA_G), 
	.vga_blue(VGA_B)
);

  dtg dtg(
	.clock(clk_out2), 
	.rst(!CPU_RESETN),
	.horiz_sync(VGA_HS), 
	.vert_sync(VGA_VS), 
	.video_on(video_on),		
	.pixel_row(pixel_row), 
	.pixel_column(pixel_column)
);


icon iconer(
	.pixel_column(pixel_column), 
	.pixel_row(pixel_row),
	.LocX_reg(LocX_reg), 
	.LocY_reg(LocY_reg),
	.BotInfo_reg(BotInfo_reg),
	.icon(icon_pixel)
);



  scale(
	.pixel_row(pixel_row),
	.pixel_column(pixel_column),
	.vid_addr(vid_addr)

);

   world_map world_map(
                      .clka(clk_out2),
                      .addra(worldmap_addr),
                      .douta(worldmap_data),
                      .clkb(clk_out2),
                      .addrb(vid_addr),
                      .doutb(world_pixel)
                    );
					
	handshake_ff handshake_ff(
	.clk50(clk_out),
	.IO_INT_ACK(IO_INT_ACK),
	.IO_BotUpdt(upd_sysregs),
	.IO_BotUpdt_Sync(IO_BotUpdt_Sync)
);
          
endmodule
