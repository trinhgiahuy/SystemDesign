// --------------------------------------------------------------------
// Copyright (c) 2007 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	Bayer to RGB format support row and column mirror
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| 		Changes Made:
//   V1.0 :| Johnny Fan        :| 07/07/09:|      Initial Revision
//   V2.0 :| Peli Li           :| 2010/11/09:|    Revised for row mirror
// --------------------------------------------------------------------
module	RAW_to_RGB		(	iCLK,iRST_n,
								//Read Port 1
								iData,
								iDval,
								oRed,
								oGreen,
								oBlue,
								oDval,
								iMIRROR,
								iX_Cont,
								iY_Cont,
								iNext
							);


input			iCLK,iRST_n;
input	[11:0]	iData;
input			iDval;
output	[11:0]	oRed;
output	[11:0]	oGreen;
output	[11:0]	oBlue;
output			oDval;
input		      iMIRROR;
input	[15:0]	iX_Cont;
input	[15:0]	iY_Cont;

input iNext;
reg rNext;

wire	[11:0]	wData0;
wire	[11:0]	wData1;
//wire	[11:0]	wData2;

reg		[11:0]	rRed;
reg		[12:0]	rGreen;
reg		[11:0]	rBlue;
reg				   rDval;
reg		[11:0]	wData0_d1;//,wData0_d2;
reg		[11:0]	wData1_d1;//,wData1_d2;
//reg		[11:0]	wData2_d1,wData2_d2;

wire				oDval;

reg				dval_ctrl;
reg				dval_ctrl_en;
wire  [1:0]  data_control;
//out
assign	oRed	=	rRed;
assign	oGreen	=	rGreen[12:1];
assign	oBlue	=	rBlue;

Line_Buffer	L1	(
					.clken(iDval),
					.clock(iCLK),
					.shiftin(iData),
					.shiftout(),
//					.taps1x(wData0),
//					.taps0x(wData1),
					.taps({wData0,wData1})
				);

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
				dval_ctrl<=0;
		else
				if(iY_Cont>1)
					dval_ctrl<=1;
				else
					dval_ctrl<=0;
	end

always@(posedge dval_ctrl or negedge iRST_n)
	begin
		if (!iRST_n)
				dval_ctrl_en<=0;
		else
				dval_ctrl_en<=1;
	end

assign oDval 		= dval_ctrl_en ?  rDval : 1'b0;

//assign  data_control = {iMIRROR?~iY_Cont[0]:iY_Cont[0],iMIRROR?iX_Cont[0]:~iX_Cont[0]};
assign  data_control = {iY_Cont[0],iMIRROR?iX_Cont[0]:~iX_Cont[0]};

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			begin
				wData0_d1<=0;
				wData1_d1<=0;
	         rDval    <=0;
			end
		else
			begin
				wData0_d1<=wData0;
				wData1_d1<=wData1;
				
		      rDval	   <=iDval;
			end
	end		
	
always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			begin
				rRed<=0;
				rGreen<=0;
				rBlue<=0;	
			end

		else if ( data_control== 2'b10)
			begin
				rRed	 <=	wData0;
			   rGreen <=	wData0_d1+wData1;
			   rBlue	 <=	wData1_d1;
			end	
		else if ( data_control== 2'b11)
			begin
				rRed	 <=	wData0_d1;
			   rGreen <=	wData0+wData1_d1;
			   rBlue	 <=	wData1;
			end
	    	
		else if ( data_control== 2'b00)
			begin
				rRed	 <=	wData1;
			   rGreen <=	wData0+wData1_d1;
			   rBlue	 <=	wData0_d1;
			end	
		
	   else if ( data_control== 2'b01)
			begin
				rRed	 <=	wData1_d1;
			   rGreen <=	wData0_d1+wData1;
			   rBlue	 <=	wData0;
			end		
		
		
	end


endmodule
