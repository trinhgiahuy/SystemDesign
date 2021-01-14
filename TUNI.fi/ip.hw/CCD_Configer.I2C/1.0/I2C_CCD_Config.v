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
// Major Functions:	I2C_CCD_Config
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Johnny FAN        :| 07/07/09  :| Initial Revision
//   V2.0 :| Peli Li           :| 2010/11/10:| add RGB offset setting
// --------------------------------------------------------------------

module CCD_Configer_I2C (	//	Host Side
						iCLK,
						iRST_N,
						iMIRROR_SW,
						//	I2C Side
						I2C_SCLK,
						I2C_SDAT,
						iSetConf,
						igreen1_gain,
						iblue_gain,
						ired_gain,
						igreen2_gain,
						//iread_mode1,
						sensor_exposure,
						sensor_start_row,
						sensor_start_column,
						sensor_row_size,
						sensor_column_size,
						sensor_row_mode,
						sensor_column_mode
						);
						
//	Host Side
input			   iCLK;
input			   iRST_N;
input 			iMIRROR_SW;

//	I2C Side
output		   I2C_SCLK;
inout		      I2C_SDAT;

//	Internal Registers/Wires
reg	[15:0]	mI2C_CLK_DIV;
reg	[31:0]	mI2C_DATA;
reg			   mI2C_CTRL_CLK;
reg			   mI2C_GO;
wire	      	mI2C_END;
wire	      	mI2C_ACK;
reg	[23:0]	LUT_DATA;
reg	 [5:0]	LUT_INDEX;
reg	 [3:0]	mSetup_ST;


//////////////   CMOS sensor registers setting //////////////////////

input		      iSetConf;
input	[15:0]   igreen1_gain;
input	[15:0]   iblue_gain;
input	[15:0]   ired_gain;
input	[15:0]   igreen2_gain;

reg	  [1:0]	izoom_mode_sw_delay;

input [15:0] sensor_exposure;
input [15:0] sensor_start_row;
input [15:0] sensor_start_column;
input [15:0] sensor_row_size;
input [15:0] sensor_column_size; 
input [15:0] sensor_row_mode;
input [15:0] sensor_column_mode;
wire [23:0] Mirror_d;

assign Mirror_d     = iMIRROR_SW ?  24'h20c000 : 24'h208000;		
		
wire	i2c_reset;		

assign i2c_reset = iRST_N /*&  ~exposure_set/*~exposure_adj_reset & ~combo_pulse*/ & ~iSetConf;

/////////////////////////////////////////////////////////////////////

//	Clock Setting
parameter	CLK_Freq	=	75000000;	//	50	MHz
parameter	I2C_Freq	=	20000;		//	20	KHz
//	LUT Data Number
parameter	LUT_SIZE	=	25;//28;

/////////////////////	I2C Control Clock	////////////////////////
always@(posedge iCLK or negedge i2c_reset)
begin
	if(!i2c_reset)
	begin
		mI2C_CTRL_CLK	<=	0;
		mI2C_CLK_DIV	<=	0;
	end
	else
	begin
		if( mI2C_CLK_DIV	< (CLK_Freq/I2C_Freq) )
		mI2C_CLK_DIV	<=	mI2C_CLK_DIV+1;
		else
		begin
			mI2C_CLK_DIV	<=	0;
			mI2C_CTRL_CLK	<=	~mI2C_CTRL_CLK;
		end
	end
end
////////////////////////////////////////////////////////////////////
I2C_Controller 	u0	(	.CLOCK(mI2C_CTRL_CLK),		//	Controller Work Clock
						.I2C_SCLK(I2C_SCLK),		//	I2C CLOCK
 	 	 	 	 	 	.I2C_SDAT(I2C_SDAT),		//	I2C DATA
						.I2C_DATA(mI2C_DATA),		//	DATA:[SLAVE_ADDR,SUB_ADDR,DATA]
						.GO(mI2C_GO),      			//	GO transfor
						.END(mI2C_END),				//	END transfor 
						.ACK(mI2C_ACK),				//	ACK
						.RESET(i2c_reset)
					);
////////////////////////////////////////////////////////////////////
//////////////////////	Config Control	////////////////////////////
//always@(posedge mI2C_CTRL_CLK or negedge iRST_N)
always@(posedge mI2C_CTRL_CLK or negedge i2c_reset)
begin
	if(!i2c_reset)
	begin
		LUT_INDEX	<=	0;
		mSetup_ST	<=	0;
		mI2C_GO		<=	0;

	end
	
	else if(LUT_INDEX<LUT_SIZE)
		begin
			case(mSetup_ST)
			0:	begin
					mI2C_DATA	<=	{8'hBA,LUT_DATA};
					mI2C_GO		<=	1;
					mSetup_ST	<=	1;
				end
			1:	begin
					if(mI2C_END)
					begin
						if(!mI2C_ACK)
						mSetup_ST	<=	2;
						else
						mSetup_ST	<=	0;							
						mI2C_GO		<=	0;
					end
				end
			2:	begin
					LUT_INDEX	<=	LUT_INDEX+1;
					mSetup_ST	<=	0;
				end
			endcase
		end
end
////////////////////////////////////////////////////////////////////
/////////////////////	Config Data LUT	  //////////////////////////		
always
begin
	case(LUT_INDEX)
	0	:	LUT_DATA	<=	24'h000000;
	1	:	LUT_DATA	<=	Mirror_d;				//	Mirror Row and Columns
	2	:	LUT_DATA	<=	{8'h09, sensor_exposure};//	Exposure
	3	:	LUT_DATA	<=	24'h050000;				//	H_Blanking
	4	:	LUT_DATA	<=	24'h060019;				//	V_Blanking	
	5	:	LUT_DATA	<=	24'h0A8000;				//	change latch
	6	:	LUT_DATA	<=	{8'h2B, igreen1_gain}; 				//	Green 1 Gain
	7	:	LUT_DATA	<=	{8'h2C, iblue_gain}; 				//	Blue Gain
	8	:	LUT_DATA	<=	{8'h2D, ired_gain}; 				//	Red Gain
	9	:	LUT_DATA	<=	{8'h2E, igreen2_gain};				  //	Green 2 Gain
	10	:	LUT_DATA	<=	24'h100051;				//	set up PLL power on
//`ifdef VGA_640x480p60	
//	11	:	LUT_DATA	<=	24'h111f04;				//	PLL_m_Factor<<8+PLL_n_Divider
//	12	:	LUT_DATA	<=	24'h120001;				//	PLL_p1_Divider
//`else
	11	:	LUT_DATA	<=	24'h111805;				//	PLL_m_Factor<<8+PLL_n_Divider
	12	:	LUT_DATA	<=	24'h120003;				//	PLL_p1_Divider
//`endif
	13	:	LUT_DATA	<=	24'h100053;				//	set USE PLL	 
	14	:	LUT_DATA	<=	24'h980000;				//	disble calibration 	
	15	:	LUT_DATA	<=	24'hA00000;				//	Test pattern control 
	16	:	LUT_DATA	<=	24'hA10000;				//	Test green pattern value
	17	:	LUT_DATA	<=	24'hA20FFF;				//	Test red pattern value
	18	:	LUT_DATA	<=	{8'h01,sensor_start_row};	//	set start row	
	19	:	LUT_DATA	<=	{8'h02,sensor_start_column};	//	set start column 	
	20	:	LUT_DATA	<=	{8'h03,sensor_row_size};		//	set row size	
	21	:	LUT_DATA	<=	{8'h04,sensor_column_size};	//	set column size
	22	:	LUT_DATA	<=	{8'h22,sensor_row_mode};		//	set row mode in bin mode
	23	:	LUT_DATA	<=	{8'h23,sensor_column_mode};	//	set column mode	 in bin mode
	24	:	LUT_DATA	<=	24'h4900A8;  				//	row black target		
	//25	:	LUT_DATA	<=	24'h080000;  				//	shutter width upper
	//26	:	LUT_DATA	<=	24'h090797;  				//	shutter width lower
	//27	:	LUT_DATA	<=	{8'h1E,iread_mode1};  				//	read mode 1
	default:LUT_DATA	<=	24'h000000;
	endcase
end

endmodule