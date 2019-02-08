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
                        inout  [ 8          :1] JB,
                        input                   UART_TXD_IN);

  // Press btnCpuReset to reset the processor. 
        
  wire clk_out; 
  wire tck_in, tck;
  
  reg MotCtl_in, LocX_reg, LocY_reg, Sensors_reg, BotInfo_reg, Bot_Config_reg, upd_sysregs;
  
  clk_wiz_0 clk_wiz_0(.clk_in1(CLK100MHZ), .clk_out1(clk_out), .clk_out2(clk_out2));
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
                    .IO_Switch(SW),
                    .IO_PB({BTNU, BTND, BTNL, BTNC, BTNR}),
                    .IO_LED(LED),
                    .UART_RX(UART_TXD_IN));
                    
  rojobot31 inst (
                      .MotCtl_in(MotCtl_in),
                      .LocX_reg(LocX_reg),
                      .LocY_reg(LocY_reg),
                      .Sensors_reg(Sensors_reg),
                      .BotInfo_reg(BotInfo_reg),
                      .worldmap_addr(worldmap_addr),
                      .worldmap_data(worldmap_data),
                      .clk_in(clk_out2),
                      .reset(CPU_RESETN),
                      .upd_sysregs(upd_sysregs),
                      .Bot_Config_reg(Bot_Config_reg)
                    );                 
                    
 world_map world_map(
                      .clka(clk_out2),
                      .addra(worldmap_addr),
                      .douta(worldmap_data),
                      .clkb(),
                      .addrb(),
                      .doutb()
                    );

           
          
endmodule
