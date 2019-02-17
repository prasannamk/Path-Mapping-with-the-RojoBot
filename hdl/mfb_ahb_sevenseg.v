`timescale 1ns / 1ps
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
// The circuit is a AHB-lite bus peripheral for the seven segment display
// device onboard the NexysDDR4. We simply take in the inputs from the AHB Bus
// and then give the inputs to a register which will provide us with a multiplexed
// seven sehment output.
// 
///////////////////////////////////////////////////////////////////////////
`include "mfp_ahb_const.vh"
//Main module whic has the added definitions for the seven segment display. 

module mfp_ahb_segment(
    input                        HCLK,
    input                        HRESETn,
    input      [ 31          :0] HADDR,
    input      [  1          :0] HTRANS,
    input      [ 31          :0] HWDATA,
    input                        HWRITE,
    input                        HSEL,

	// The seven segment signals that will be propagated till the top module
	output  [7:0]	IO_AN,
	output  IO_CA, IO_CB, IO_CC, IO_CD, IO_CE, IO_CF, IO_CG,
	output  IO_DP
);
    
    reg	[31:0]  HRDATA_int;

	reg [7:0]   Seg_Enable;

	reg [63:0]  Seg_Data;

	reg [7:0]   Decimal_Enable;
	
	reg [31:0]  HADDR_d;
        
    reg         HWRITE_d;
    
    reg         HSEL_d;
    
    reg  [1:0]  HTRANS_d;
    
    wire        we;            // write enable
	

	// Lower module instantiation which will provide the seven segment output
	mfp_ahb_sevensegtimer seven_segment_driver(
							.clk(HCLK)
							,.resetn(HRESETn)
							,.EN(Seg_Enable)
							,.DIGITS(Seg_Data)
							,.dp(Decimal_Enable)
							,.DISPENOUT(IO_AN)
							,.DISPOUT({IO_DP,IO_CA, IO_CB, IO_CC, IO_CD, IO_CE, IO_CF, IO_CG})
							);

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

    always @(posedge HCLK or negedge HRESETn)
	begin
		if (~HRESETn) begin
			Seg_Enable <= 8'b0;
			Seg_Data <= 64'h0;
			Decimal_Enable <= 8'b0;
		end else if (we)
		begin
			case (HADDR_d)
				//segment enable register
				`H_SSEN_ADDR: Seg_Enable <= HWDATA[7:0];
				//segment MSB 4 digits
				`H_SSUP_ADDR : Seg_Data[63:32] <= HWDATA;
				//segment LSB 4 digits
				`H_SSLW_ADDR: Seg_Data[31:0] <= HWDATA;
				//decimal point enable register
				`H_SSDM_ADDR: Decimal_Enable <= HWDATA[7:0];
			endcase
		end
	end	 
	

    
endmodule
