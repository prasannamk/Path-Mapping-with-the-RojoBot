// Seven-segment display timer for the Nexys4 DDR board
//
//  
// Created By:	    Prasanna_Kulkarni and Atharva_Mahindarkar
// Last Modified:	24-January-2019 (SY)
//
// Revision History:
// -----------------
// Jan-2019   AM_PK		Created this module for the NexysDDR4 Starter Board
//
//
// Description:
// ------------
// The circuit is a AHB-lite bus peripheral for the rojobot
// We simply take in the inputs from the AHB Bus
// and then give the inputs to a register which will provide us with a multiplexed
// output.
// 
///////////////////////////////////////////////////////////////////////////
/*
					
`define H_BOTINFO_ADDR			(32'h1f80000C)
`define H_BOTCNTRL_ADDR			(32'h1f800010)
`define H_BOTUPDT_ADDR			(32'h1f800014)
`define H_INTACK_ADDR			(32'h1f800018)
*/

module mfp_ahb_rojo(
	input                        HCLK,
    input                        HRESETn,
    input      [ 31          :0] HADDR,
    input      [  1          :0] HTRANS,
    input      [ 31          :0] HWDATA,
    input                        HWRITE,
    input                        HSEL,
    output reg [ 31          :0] HRDATA,
	
	output	reg [7:0]	IO_BotCtrl,
	input	 [31:0]	IO_BotInfo,
	output	reg [0:0]	IO_INT_ACK,
	input	 [0:0]	IO_BotUpdt_Sync
);
	
    reg	[31:0]  HRDATA_int;
	
	reg [31:0]  HADDR_d;
        
    reg         HWRITE_d;
    
    reg         HSEL_d;
    
    reg  [1:0]  HTRANS_d;
	
	reg  [7:0]  IO_BotCtrl_reg;
	
	reg  [31:0]  IO_BotInfo_reg;
	
	reg  [0:0]  IO_INT_ACK_reg;
    
	reg  [0:0]  IO_BotUpdt_Sync_reg;
	
    wire        we;      
	
	

	
	// delay HADDR, HWRITE, HSEL, and HTRANS to align with HWDATA for writing
	always @ (posedge HCLK) 
	begin
		HADDR_d  <= HADDR;
		HWRITE_d <= HWRITE;
		HSEL_d   <= HSEL;
		HTRANS_d <= HTRANS;
	end
  
	// overall write enable signal
	assign we = (HTRANS_d != `HTRANS_IDLE) & HSEL_d & HWRITE_d;
	
	// Write Procedure
	always @(posedge HCLK or negedge HRESETn)
		begin
		if (~HRESETn) 
			// Default values to be assigned upon reset
			begin
				IO_BotCtrl = 8'b0;
				IO_INT_ACK = 1'b0;
			end 
		else 
			begin
			case (HADDR_d)
				`H_BOTCNTRL_ADDR: IO_BotCtrl <= HWDATA[7:0];
				`H_INTACK_ADDR:   IO_INT_ACK <= HWDATA [0:0];
			endcase
			end
		end	 
	

	// Read Procedure
	always @(posedge HCLK or negedge HRESETn)
		begin
		if (~HRESETn)
			begin
			// Default values to be assigned upon reset
			HRDATA <= 32'h0;
			end
		else
			begin
			case (HADDR)
				`H_BOTINFO_ADDR: HRDATA <= IO_BotInfo;
				`H_BOTUPDT_ADDR: HRDATA <= IO_BotUpdt_Sync;
				default:    HRDATA <= 32'h00000000;
			endcase
			end
		end
endmodule
