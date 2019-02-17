// Seven-segment display timer for the Nexys4 DDR board
//
//  
// Created By:	    Prasanna_Kulkarni and Atharva_Mahindarkar
// Last Modified:	7-February-2019 
//
// Revision History:
// -----------------
// Jan-2019   AM_PK		Created this module for the NexysDDR4 Starter Board
//
//
// Description:
// ------------
// This circuit is the basic handshaking F/F used to signal the updation
// of the RojoBot status.  This peripheral needs to be accesible under the AHB-lite
// interface.
// 
///////////////////////////////////////////////////////////////////////////

module handshake_ff(
	input clk50,
	input [0:0] IO_INT_ACK,
	input [0:0] IO_BotUpdt,
	output reg[0:0] IO_BotUpdt_Sync
);


always @ (posedge clk50) 
begin  
if (IO_INT_ACK == 1'b1) 
		begin    
		IO_BotUpdt_Sync <= 1'b0;  
		end  
	else 
	if (IO_BotUpdt == 1'b1) 
		begin                 
		IO_BotUpdt_Sync <= 1'b1;  
		end 
	else
		begin   
		IO_BotUpdt_Sync <= IO_BotUpdt_Sync;  
		end 
end 

endmodule