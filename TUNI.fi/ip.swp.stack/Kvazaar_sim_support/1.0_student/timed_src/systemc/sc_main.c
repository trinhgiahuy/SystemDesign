/*---------------------------------------------------------------------------
*  File:	main.c
*
*  Purpose: SystemC top level for Intra Prediction Accelerator and Kvazaar
*            
*  Author:  Panu Sjövall <panu.sjovall@tut.fi>
*
*  Created: 23/02/2016
*
*  License: GPLv2 Copyright TUT
*
**---------------------------------------------------------------------------
*/
#include "sc_kvazaar.h"
#include "sc_kvazaar_ip_sub.h"
#include "ip_global.h"
#include "ip_config.h"
#include "ip_ctrl.h"
#include "ip_get_ang_pos.h" 
#include "ip_get_ang_neg.h" 
#include "ip_get_ang_zero.h" 
#include "ip_get_planar.h" 
#include "ip_get_dc.h" 
#include "ip_sad.h"
#include <string>
#include <sstream>

#include "exploration.h"

kvazaar* kvazaar_global;

SC_MODULE(SYSTEM)
{
	//## All component pointers ###############
	kvazaar *kvazaar0;
    kvazaar_ip_sub *kvazaar_ip_sub0;
    
	ip_config *ip_config0;
	ip_ctrl *ip_ctrl0;
    
    ip_get_planar *ip_get_planar1;
    ip_get_dc *ip_get_dc2;

    ip_get_ang_pos *ip_get_ang_pos3_35;
    ip_get_ang_pos *ip_get_ang_pos4_34;
    ip_get_ang_pos *ip_get_ang_pos5_33;
    ip_get_ang_pos *ip_get_ang_pos6_32;
    ip_get_ang_pos *ip_get_ang_pos7_31;
    ip_get_ang_pos *ip_get_ang_pos8_30;
    ip_get_ang_pos *ip_get_ang_pos9_29;
    ip_get_ang_pos *ip_get_ang_pos10_28;

    ip_get_ang_zero *ip_get_ang_zero11;

    ip_get_ang_neg *ip_get_ang_neg12;
    ip_get_ang_neg *ip_get_ang_neg13;
    ip_get_ang_neg *ip_get_ang_neg14;
    ip_get_ang_neg *ip_get_ang_neg15;
    ip_get_ang_neg *ip_get_ang_neg16;
    ip_get_ang_neg *ip_get_ang_neg17;
    ip_get_ang_neg *ip_get_ang_neg18;
    ip_get_ang_neg *ip_get_ang_neg19;
    ip_get_ang_neg *ip_get_ang_neg20;
    ip_get_ang_neg *ip_get_ang_neg21;
    ip_get_ang_neg *ip_get_ang_neg22;
    ip_get_ang_neg *ip_get_ang_neg23;
    ip_get_ang_neg *ip_get_ang_neg24;
    ip_get_ang_neg *ip_get_ang_neg25;
    ip_get_ang_neg *ip_get_ang_neg26;

    ip_get_ang_zero *ip_get_ang_zero27;

    ip_sad *ip_sad0;

	//#########################################
	
	//############ All signals ################
	
    sc_clock clk_sig;
    sc_signal<bool> rst_sig;

    Signal<sc_uint<32> > out1_sig;
    Signal<sc_uint<32> > out2_sig;
    Signal<sc_uint<32> > out3_sig;
    Signal<sc_uint<32> > out4_sig;
    Signal<sc_uint<32> > out5_sig;
    Signal<sc_uint<32> > out6_sig;
    Signal<sc_uint<32> > out7_sig;
    Signal<sc_uint<32> > out8_sig;
    Signal<sc_uint<32> > out9_sig;
    Signal<sc_uint<32> > out10_sig;
    Signal<sc_uint<32> > out11_sig;
    Signal<sc_uint<32> > out12_sig;
    Signal<sc_uint<32> > out13_sig;
    Signal<sc_uint<32> > out14_sig;
    Signal<sc_uint<32> > out15_sig;
    Signal<sc_uint<32> > out16_sig;
    Signal<sc_uint<32> > out17_sig;
    Signal<sc_uint<32> > out18_sig;
    Signal<sc_uint<32> > out19_sig;
    Signal<sc_uint<32> > out20_sig;
    Signal<sc_uint<32> > out21_sig;
    Signal<sc_uint<32> > out22_sig;
    Signal<sc_uint<32> > out23_sig;
    Signal<sc_uint<32> > out24_sig;
    Signal<sc_uint<32> > out25_sig;
    Signal<sc_uint<32> > out26_sig;
    Signal<sc_uint<32> > out27_sig;

    Signal<sc_uint<32> > config_sig;
    Signal<sc_uint<32> > ctrl_config_sig;
	Signal<sc_uint<32> > sad_config_sig;
    Signal<sc_uint<16> > unfiltered1_sig;
    Signal<sc_uint<16> > unfiltered2_sig;

    Signal<sc_uint<16> > in1_sig;
    Signal<sc_uint<16> > in2_sig;
    Signal<sc_uint<16> > in3_sig;
    Signal<sc_uint<16> > in4_sig;
    Signal<sc_uint<16> > in5_sig;
    Signal<sc_uint<16> > in6_sig;
    Signal<sc_uint<16> > in7_sig;
    Signal<sc_uint<16> > in8_sig;
    Signal<sc_uint<16> > in9_sig;
    Signal<sc_uint<16> > in10_sig;
    Signal<sc_uint<16> > in11_sig;
    Signal<sc_uint<16> > in12_sig;
    Signal<sc_uint<16> > in13_sig;
    Signal<sc_uint<16> > in14_sig;
    Signal<sc_uint<16> > in15_sig;
    Signal<sc_uint<16> > in16_sig;
    Signal<sc_uint<16> > in17_sig;
    Signal<sc_uint<16> > in18_sig;
    Signal<sc_uint<16> > in19_sig;
    Signal<sc_uint<16> > in20_sig;
    Signal<sc_uint<16> > in21_sig;
    Signal<sc_uint<16> > in22_sig;
    Signal<sc_uint<16> > in23_sig;
    Signal<sc_uint<16> > in24_sig;
    Signal<sc_uint<16> > in25_sig;
    Signal<sc_uint<16> > in26_sig;
    Signal<sc_uint<16> > in27_sig;
    Signal<sc_uint<16> > in28_sig;
    Signal<sc_uint<16> > in29_sig;
    Signal<sc_uint<16> > in30_sig;
    Signal<sc_uint<16> > in31_sig;
    Signal<sc_uint<16> > in32_sig;
    Signal<sc_uint<16> > in33_sig;
    Signal<sc_uint<16> > in34_sig;
    Signal<sc_uint<16> > in35_sig;

    Signal<sc_uint<32> > orig_data_sig;
    
	sc_signal<sc_uint<32> > result_sig;
	sc_signal<bool> lcu_loaded_sig;
	sc_signal<bool> lambda_loaded_sig;
    sc_signal<bool> result_ready_sig;

	//#########################################
	
	sc_event irq;
	
    Signal<sc_uint<32> >* ctrl_signals[35];
    Signal<sc_uint<16> >* sad_signals[35];

	// SYSTEM constructor
    SC_CTOR(SYSTEM): clk_sig("clk_sig", period_ns_c ,SC_NS)
    {	
		// Add all ctrl->pred + pred->sad signals to an array to ease handling
		sad_signals[0] = &in1_sig;
		sad_signals[1] = &in2_sig;
		sad_signals[2] = &in3_sig;
		sad_signals[3] = &in4_sig;
		sad_signals[4] = &in5_sig;
		sad_signals[5] = &in6_sig;
		sad_signals[6] = &in7_sig;
		sad_signals[7] = &in8_sig;
		sad_signals[8] = &in9_sig;
		sad_signals[9] = &in10_sig;
		sad_signals[10] = &in11_sig;
		sad_signals[11] = &in12_sig;
		sad_signals[12] = &in13_sig;
		sad_signals[13] = &in14_sig;
		sad_signals[14] = &in15_sig;
		sad_signals[15] = &in16_sig;
		sad_signals[16] = &in17_sig;
		sad_signals[17] = &in18_sig;
		sad_signals[18] = &in19_sig;
		sad_signals[19] = &in20_sig;
		sad_signals[20] = &in21_sig;
		sad_signals[21] = &in22_sig;
		sad_signals[22] = &in23_sig;
		sad_signals[23] = &in24_sig;
		sad_signals[24] = &in25_sig;
		sad_signals[25] = &in26_sig;
		sad_signals[26] = &in27_sig;
		sad_signals[27] = &in28_sig;
		sad_signals[28] = &in29_sig;
		sad_signals[29] = &in30_sig;
		sad_signals[30] = &in31_sig;
		sad_signals[31] = &in32_sig;
		sad_signals[32] = &in33_sig;
		sad_signals[33] = &in34_sig;
		sad_signals[34] = &in35_sig;

		ctrl_signals[0] = &out1_sig;
		ctrl_signals[1] = &out2_sig;
		ctrl_signals[2] = &out3_sig;
		ctrl_signals[3] = &out4_sig;
		ctrl_signals[4] = &out5_sig;
		ctrl_signals[5] = &out6_sig;
		ctrl_signals[6] = &out7_sig;
		ctrl_signals[7] = &out8_sig;
		ctrl_signals[8] = &out9_sig;
		ctrl_signals[9] = &out10_sig;
		ctrl_signals[10] = &out11_sig;
		ctrl_signals[11] = &out12_sig;
		ctrl_signals[12] = &out13_sig;
		ctrl_signals[13] = &out14_sig;
		ctrl_signals[14] = &out15_sig;
		ctrl_signals[15] = &out16_sig;
		ctrl_signals[16] = &out17_sig;
		ctrl_signals[17] = &out18_sig;
		ctrl_signals[18] = &out19_sig;
		ctrl_signals[19] = &out20_sig;
		ctrl_signals[20] = &out21_sig;
		ctrl_signals[21] = &out22_sig;
		ctrl_signals[22] = &out23_sig;
		ctrl_signals[23] = &out24_sig;
		ctrl_signals[24] = &out25_sig;
		ctrl_signals[25] = &out26_sig;
		ctrl_signals[26] = &out27_sig;
		
		//########## Create all componentes #################
		kvazaar0 = new kvazaar("kvazaar");
		kvazaar_global = kvazaar0;
		kvazaar_ip_sub0 = new kvazaar_ip_sub("kvazaar_ip_sub");
		
		ip_config0 = new ip_config("ip_config");
		ip_ctrl0 = new ip_ctrl("ip_ctrl");

		ip_get_planar1 = new ip_get_planar("ip_get_planar1");
		ip_get_dc2 = new ip_get_dc("ip_get_dc2");
		
		ip_get_ang_pos3_35 = new ip_get_ang_pos("ip_get_ang_pos3_35");
		ip_get_ang_pos4_34 = new ip_get_ang_pos("ip_get_ang_pos4_34");
		ip_get_ang_pos5_33 = new ip_get_ang_pos("ip_get_ang_pos5_33");
		ip_get_ang_pos6_32 = new ip_get_ang_pos("ip_get_ang_pos6_32");
		ip_get_ang_pos7_31 = new ip_get_ang_pos("ip_get_ang_pos7_31");
		ip_get_ang_pos8_30 = new ip_get_ang_pos("ip_get_ang_pos8_30");
		ip_get_ang_pos9_29 = new ip_get_ang_pos("ip_get_ang_pos9_29");
		ip_get_ang_pos10_28 = new ip_get_ang_pos("ip_get_ang_pos10_28");

		ip_get_ang_zero11 = new ip_get_ang_zero("ip_get_ang_zero11");

		ip_get_ang_neg12 = new ip_get_ang_neg("ip_get_ang_neg12");
		ip_get_ang_neg13 = new ip_get_ang_neg("ip_get_ang_neg13");
		ip_get_ang_neg14 = new ip_get_ang_neg("ip_get_ang_neg14");
		ip_get_ang_neg15 = new ip_get_ang_neg("ip_get_ang_neg15");
		ip_get_ang_neg16 = new ip_get_ang_neg("ip_get_ang_neg16");
		ip_get_ang_neg17 = new ip_get_ang_neg("ip_get_ang_neg17");
		ip_get_ang_neg18 = new ip_get_ang_neg("ip_get_ang_neg18");
		ip_get_ang_neg19 = new ip_get_ang_neg("ip_get_ang_neg19");
		ip_get_ang_neg20 = new ip_get_ang_neg("ip_get_ang_neg20");
		ip_get_ang_neg21 = new ip_get_ang_neg("ip_get_ang_neg21");
		ip_get_ang_neg22 = new ip_get_ang_neg("ip_get_ang_neg22");
		ip_get_ang_neg23 = new ip_get_ang_neg("ip_get_ang_neg23");
		ip_get_ang_neg24 = new ip_get_ang_neg("ip_get_ang_neg24");
		ip_get_ang_neg25 = new ip_get_ang_neg("ip_get_ang_neg25");
		ip_get_ang_neg26 = new ip_get_ang_neg("ip_get_ang_neg26");

		ip_get_ang_zero27 = new ip_get_ang_zero("ip_get_ang_zero27");
		
		ip_sad0 = new ip_sad("ip_sad");

		//######################################################
		
		//########## Connect all signals #######################
		ip_config0->clk(clk_sig);
		ip_ctrl0->clk(clk_sig);
		
		ip_get_planar1->clk(clk_sig);
		ip_get_dc2->clk(clk_sig);
		
		ip_get_ang_pos3_35->clk(clk_sig);
		ip_get_ang_pos4_34->clk(clk_sig);
		ip_get_ang_pos5_33->clk(clk_sig);
		ip_get_ang_pos6_32->clk(clk_sig);
		ip_get_ang_pos7_31->clk(clk_sig);
		ip_get_ang_pos8_30->clk(clk_sig);
		ip_get_ang_pos9_29->clk(clk_sig);
		ip_get_ang_pos10_28->clk(clk_sig);
		
		ip_get_ang_zero11->clk(clk_sig);
		
		ip_get_ang_neg12->clk(clk_sig);
		ip_get_ang_neg13->clk(clk_sig);
		ip_get_ang_neg14->clk(clk_sig);
		ip_get_ang_neg15->clk(clk_sig);
		ip_get_ang_neg16->clk(clk_sig);
		ip_get_ang_neg17->clk(clk_sig);
		ip_get_ang_neg18->clk(clk_sig);
		ip_get_ang_neg19->clk(clk_sig);
		ip_get_ang_neg20->clk(clk_sig);
		ip_get_ang_neg21->clk(clk_sig);
		ip_get_ang_neg22->clk(clk_sig);
		ip_get_ang_neg23->clk(clk_sig);
		ip_get_ang_neg24->clk(clk_sig);
		ip_get_ang_neg25->clk(clk_sig);
		ip_get_ang_neg26->clk(clk_sig);
		
		ip_get_ang_zero27->clk(clk_sig);
		
		ip_config0->rst(rst_sig);
		ip_ctrl0->rst(rst_sig);
		
		ip_get_planar1->rst(rst_sig);
		ip_get_dc2->rst(rst_sig);
		
		ip_get_ang_pos3_35->rst(rst_sig);
		ip_get_ang_pos4_34->rst(rst_sig);
		ip_get_ang_pos5_33->rst(rst_sig);
		ip_get_ang_pos6_32->rst(rst_sig);
		ip_get_ang_pos7_31->rst(rst_sig);
		ip_get_ang_pos8_30->rst(rst_sig);
		ip_get_ang_pos9_29->rst(rst_sig);
		ip_get_ang_pos10_28->rst(rst_sig);
		
		ip_get_ang_zero11->rst(rst_sig);
		
		ip_get_ang_neg12->rst(rst_sig);
		ip_get_ang_neg13->rst(rst_sig);
		ip_get_ang_neg14->rst(rst_sig);
		ip_get_ang_neg15->rst(rst_sig);
		ip_get_ang_neg16->rst(rst_sig);
		ip_get_ang_neg17->rst(rst_sig);
		ip_get_ang_neg18->rst(rst_sig);
		ip_get_ang_neg19->rst(rst_sig);
		ip_get_ang_neg20->rst(rst_sig);
		ip_get_ang_neg21->rst(rst_sig);
		ip_get_ang_neg22->rst(rst_sig);
		ip_get_ang_neg23->rst(rst_sig);
		ip_get_ang_neg24->rst(rst_sig);
		ip_get_ang_neg25->rst(rst_sig);
		ip_get_ang_neg26->rst(rst_sig);
		
		ip_get_ang_zero27->rst(rst_sig);
		
		kvazaar_ip_sub0->clk(clk_sig);
		kvazaar_ip_sub0->rst(rst_sig);

		kvazaar0->irq = &irq;
		kvazaar_ip_sub0->irq = &irq;

		CONNECT_CHANNELS(kvazaar_ip_sub0->config_out, ip_config0->config, config_sig);
		CONNECT_CHANNELS(kvazaar_ip_sub0->orig_out, ip_sad0->orig_data_in, orig_data_sig);
		CONNECT_CHANNELS(kvazaar_ip_sub0->top_ref_out, ip_ctrl0->unfiltered1, unfiltered1_sig);
		CONNECT_CHANNELS(kvazaar_ip_sub0->left_ref_out, ip_ctrl0->unfiltered2, unfiltered2_sig);
	
		kvazaar_ip_sub0->lcu_loaded(lcu_loaded_sig);
		kvazaar_ip_sub0->lambda_loaded(lambda_loaded_sig);
		kvazaar_ip_sub0->result_ready(result_ready_sig);
		kvazaar_ip_sub0->result_in(result_sig);
		
		kvazaar0->socket.bind(kvazaar_ip_sub0->socket);
		
		CONNECT_CHANNELS(ip_config0->ctrl_config, ip_ctrl0->config, ctrl_config_sig);
		CONNECT_CHANNELS(ip_config0->sad_config, ip_sad0->config, sad_config_sig);
		

		for(int a = 0; a < 27;a++)
		{
			ip_ctrl0->outputs[a]->lz(ctrl_signals[a]->lz);
			ip_ctrl0->outputs[a]->vz(ctrl_signals[a]->vz);
			ip_ctrl0->outputs[a]->z(ctrl_signals[a]->z);
		}

		CONNECT(ip_get_planar1->data_in,out1_sig);
		CONNECT(ip_get_dc2->data_in,out2_sig);
		
		CONNECT(ip_get_ang_pos3_35->data_in,out3_sig);
		CONNECT(ip_get_ang_pos4_34->data_in,out4_sig);
		CONNECT(ip_get_ang_pos5_33->data_in,out5_sig);
		CONNECT(ip_get_ang_pos6_32->data_in,out6_sig);
		CONNECT(ip_get_ang_pos7_31->data_in,out7_sig);
		CONNECT(ip_get_ang_pos8_30->data_in,out8_sig);
		CONNECT(ip_get_ang_pos9_29->data_in,out9_sig);
		CONNECT(ip_get_ang_pos10_28->data_in,out10_sig);
		
		CONNECT(ip_get_ang_zero11->data_in,out11_sig);
		
		CONNECT(ip_get_ang_neg12->data_in,out12_sig);
		CONNECT(ip_get_ang_neg13->data_in,out13_sig);
		CONNECT(ip_get_ang_neg14->data_in,out14_sig);
		CONNECT(ip_get_ang_neg15->data_in,out15_sig);
		CONNECT(ip_get_ang_neg16->data_in,out16_sig);
		CONNECT(ip_get_ang_neg17->data_in,out17_sig);
		CONNECT(ip_get_ang_neg18->data_in,out18_sig);
		CONNECT(ip_get_ang_neg19->data_in,out19_sig);
		CONNECT(ip_get_ang_neg20->data_in,out20_sig);
		CONNECT(ip_get_ang_neg21->data_in,out21_sig);
		CONNECT(ip_get_ang_neg22->data_in,out22_sig);
		CONNECT(ip_get_ang_neg23->data_in,out23_sig);
		CONNECT(ip_get_ang_neg24->data_in,out24_sig);
		CONNECT(ip_get_ang_neg25->data_in,out25_sig);
		CONNECT(ip_get_ang_neg26->data_in,out26_sig);
		
		CONNECT(ip_get_ang_zero27->data_in,out27_sig);

		CONNECT(ip_get_planar1->data_out,in1_sig);
		CONNECT(ip_get_dc2->data_out,in2_sig);
		
		CONNECT(ip_get_ang_pos3_35->data_out_ver,in35_sig);
		CONNECT(ip_get_ang_pos4_34->data_out_ver,in34_sig);
		CONNECT(ip_get_ang_pos5_33->data_out_ver,in33_sig);
		CONNECT(ip_get_ang_pos6_32->data_out_ver,in32_sig);
		CONNECT(ip_get_ang_pos7_31->data_out_ver,in31_sig);
		CONNECT(ip_get_ang_pos8_30->data_out_ver,in30_sig);
		CONNECT(ip_get_ang_pos9_29->data_out_ver,in29_sig);
		CONNECT(ip_get_ang_pos10_28->data_out_ver,in28_sig);
		
		CONNECT(ip_get_ang_pos3_35->data_out_hor,in3_sig);
		CONNECT(ip_get_ang_pos4_34->data_out_hor,in4_sig);
		CONNECT(ip_get_ang_pos5_33->data_out_hor,in5_sig);
		CONNECT(ip_get_ang_pos6_32->data_out_hor,in6_sig);
		CONNECT(ip_get_ang_pos7_31->data_out_hor,in7_sig);
		CONNECT(ip_get_ang_pos8_30->data_out_hor,in8_sig);
		CONNECT(ip_get_ang_pos9_29->data_out_hor,in9_sig);
		CONNECT(ip_get_ang_pos10_28->data_out_hor,in10_sig);
		
		CONNECT(ip_get_ang_zero11->data_out,in11_sig);
		
		CONNECT(ip_get_ang_neg12->data_out,in12_sig);
		CONNECT(ip_get_ang_neg13->data_out,in13_sig);
		CONNECT(ip_get_ang_neg14->data_out,in14_sig);
		CONNECT(ip_get_ang_neg15->data_out,in15_sig);
		CONNECT(ip_get_ang_neg16->data_out,in16_sig);
		CONNECT(ip_get_ang_neg17->data_out,in17_sig);
		CONNECT(ip_get_ang_neg18->data_out,in18_sig);
		CONNECT(ip_get_ang_neg19->data_out,in19_sig);
		CONNECT(ip_get_ang_neg20->data_out,in20_sig);
		CONNECT(ip_get_ang_neg21->data_out,in21_sig);
		CONNECT(ip_get_ang_neg22->data_out,in22_sig);
		CONNECT(ip_get_ang_neg23->data_out,in23_sig);
		CONNECT(ip_get_ang_neg24->data_out,in24_sig);
		CONNECT(ip_get_ang_neg25->data_out,in25_sig);
		CONNECT(ip_get_ang_neg26->data_out,in26_sig);
		
		CONNECT(ip_get_ang_zero27->data_out,in27_sig);

		ip_sad0->clk(clk_sig);
		ip_sad0->rst(rst_sig);
		for(int a = 0; a < 35;a++)
		{
			ip_sad0->inputs[a]->lz(sad_signals[a]->lz);
			ip_sad0->inputs[a]->vz(sad_signals[a]->vz);
			ip_sad0->inputs[a]->z(sad_signals[a]->z);
		}

		ip_sad0->result(result_sig);
		ip_sad0->lcu_loaded(lcu_loaded_sig);
		ip_sad0->lambda_loaded(lambda_loaded_sig);
		ip_sad0->result_ready(result_ready_sig);
		
		//######################################################

    }

	// Destructor
    ~SYSTEM()
    {
		delete kvazaar0;
		
		delete kvazaar_ip_sub0;
		
		delete ip_ctrl0;
		delete ip_get_planar1;
		delete ip_get_dc2;
		
		delete ip_get_ang_pos3_35;
		delete ip_get_ang_pos4_34;
		delete ip_get_ang_pos5_33;
		delete ip_get_ang_pos6_32;
		delete ip_get_ang_pos7_31;
		delete ip_get_ang_pos8_30;
		delete ip_get_ang_pos9_29;
		delete ip_get_ang_pos10_28;
		
		delete ip_get_ang_zero11;
		
		delete ip_get_ang_neg12;
		delete ip_get_ang_neg13;
		delete ip_get_ang_neg14;
		delete ip_get_ang_neg15;
		delete ip_get_ang_neg16;
		delete ip_get_ang_neg17;
		delete ip_get_ang_neg18;
		delete ip_get_ang_neg19;
		delete ip_get_ang_neg20;
		delete ip_get_ang_neg21;
		delete ip_get_ang_neg22;
		delete ip_get_ang_neg23;
		delete ip_get_ang_neg24;
		delete ip_get_ang_neg25;
		delete ip_get_ang_neg26;
		
		delete ip_get_ang_zero27;
		
		delete ip_sad0;
    }
};

SYSTEM *top = NULL;

// SystemC main function
int sc_main(int argc, char* argv[])
{
    top = new SYSTEM("top");

    top->kvazaar0->argc = argc;
    for(int a = 0; a < argc;a++)
    {
		top->kvazaar0->argv[a] = argv[a];
    }
	
	// Add signals to wave output
#if defined(OUTPUT_WAVE)
    sc_trace_file *fp;
    fp = sc_create_vcd_trace_file("wave");
    fp->set_time_unit(100,SC_PS);

    sc_trace(fp,top->clk_sig,"clk");
    sc_trace(fp,top->rst_sig,"rst");
       
    sc_trace(fp,top->config_sig.lz,"config_lz");
    sc_trace(fp,top->config_sig.vz,"config_vz");
    sc_trace(fp,top->config_sig.z,"config_z");

	sc_trace(fp,top->ctrl_config_sig.lz,"ctrl_config_lz");
    sc_trace(fp,top->ctrl_config_sig.vz,"ctrl_config_vz");
    sc_trace(fp,top->ctrl_config_sig.z,"ctrl_config_z");
	
    sc_trace(fp,top->sad_config_sig.lz,"sad_config_lz");	
    sc_trace(fp,top->sad_config_sig.vz,"sad_config_vz");	
    sc_trace(fp,top->sad_config_sig.z,"sad_config_z");

    sc_trace(fp,top->unfiltered1_sig.lz,"unfiltered1_lz");
    sc_trace(fp,top->unfiltered1_sig.vz,"unfiltered1_vz");
    sc_trace(fp,top->unfiltered1_sig.z,"unfiltered1_z");
    
    sc_trace(fp,top->unfiltered2_sig.lz,"unfiltered2_lz");	
    sc_trace(fp,top->unfiltered2_sig.vz,"unfitlered2_vz");	
    sc_trace(fp,top->unfiltered2_sig.z,"unfiltered2_z");

    sc_trace(fp,top->orig_data_sig.lz,"orig_data_lz");
    sc_trace(fp,top->orig_data_sig.vz,"orig_data_vz");
    sc_trace(fp,top->orig_data_sig.z,"orig_data_z");

    sc_trace(fp,top->result_ready_sig,"result_ready");
    
    for(int b = 0; b < 27;b++)
    {				
		std::ostringstream ss;
		ss << b+1;
		std::string idx = ss.str();
		sc_trace(fp,top->ctrl_signals[b]->lz,"ctrl_to_pred" + idx + "_lz");
		sc_trace(fp,top->ctrl_signals[b]->vz,"ctrl_to_pred" + idx + "_vz");
		sc_trace(fp,top->ctrl_signals[b]->z,"ctrl_to_pred"  + idx + "_z");
    }

    for(int b = 0; b < 35;b++)
    {				
		std::ostringstream ss;
		ss << b+1;
		std::string idx = ss.str();
		sc_trace(fp,top->sad_signals[b]->lz,"pred_to_sad" + idx + "_lz");
		sc_trace(fp,top->sad_signals[b]->vz,"pred_to_sad" + idx + "_vz");
		sc_trace(fp,top->sad_signals[b]->z,"pred_to_sad"  + idx + "_z");
    }
#endif
    sc_start();
#if defined(OUTPUT_WAVE)
    sc_close_vcd_trace_file(fp);
#endif
    return 0;
}
