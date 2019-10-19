`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 	PolySoftique Inc.
// Engineer: 	VDT
// //
// Create Date:   20:13:05 07/25/2016
// Design Name:   sdc_controller_mod
// Module Name:   C:/FPGA_Design_Test/sd_card_ISE14/V11/PAKPUCIO_6_12_12_Copy_CS/tf/sdc_controller_mod_tb2.v
// Project Name:  PAKPUCIO
// Target Device:  Spartan 6
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sdc_controller_mod
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sdc_controller_mod_tb2;

	// Inputs
	reg         clk;
	reg         reset;
	reg         man_init_sdc_strb;
	reg         host_tst_cmd_strb;
	reg [11:0]  rd_reg_indx_puc;
	reg         wr_reg_man;
	reg [35:0]  wreg_sdc_hc_reg_man;
	reg         start_data_tf_strb;
	reg         data_in_strb;
	reg         last_set_of_data_strb;
	reg [35:0]  data;
	reg         wr_b_strb;
	reg [63:0]  fifo_data;
	reg [31:0]  sdc_rd_addr;
	reg [31:0]  sdc_wr_addr;
	reg [35:0]  tf_mode;
   //reg [5:0]   sdc_cmd_indx; 
	reg         IO_SDC1_CD_WP;
	reg         IO_SDC1_D0_in;
	reg         IO_SDC1_D1_in;
	reg         IO_SDC1_D2_in;
	reg         IO_SDC1_D3_in;
	reg         IO_SDC1_CMD_in;

	// Outputs
	wire [35:0] rd_reg_output_puc;
	wire        strt_fifo_strb;
	wire        rdy_for_nxt_pkt;
	wire        IO_SDC1_D0_out;
	wire        IO_SDC1_D1_out;
	wire        IO_SDC1_D2_out;
	wire        IO_SDC1_D3_out;
	wire        IO_SDC1_CLK;
	wire        IO_SDC1_CMD_out;
   
   integer incr;
   parameter WIDTH=64;
   reg [WIDTH-1:0] DATA;
   integer i;

	// Instantiate the Unit Under Test (UUT)
	sdc_controller_mod uut (
		.clk(clk), 
		.reset(reset), 
		.man_init_sdc_strb(man_init_sdc_strb), 
		.host_tst_cmd_strb(host_tst_cmd_strb), 
		.rd_reg_indx_puc(rd_reg_indx_puc), 
		.rd_reg_output_puc(rd_reg_output_puc), 
		.wr_reg_man(wr_reg_man), 
		.wreg_sdc_hc_reg_man(wreg_sdc_hc_reg_man), 
		.start_data_tf_strb(start_data_tf_strb), 
		.data_in_strb(data_in_strb), 
		.last_set_of_data_strb(last_set_of_data_strb), 
		.data(data), 
		.strt_fifo_strb(strt_fifo_strb), 
		.wr_b_strb(wr_b_strb), 
		.fifo_data(fifo_data), 
		.rdy_for_nxt_pkt(rdy_for_nxt_pkt), 
		.sdc_rd_addr(sdc_rd_addr), 
		.sdc_wr_addr(sdc_wr_addr), 
		.tf_mode(tf_mode), 
      //.sdc_cmd_indx(sdc_cmd_indx), 
		.IO_SDC1_CD_WP(IO_SDC1_CD_WP), 
		.IO_SDC1_D0_in(IO_SDC1_D0_in), 
		.IO_SDC1_D0_out(IO_SDC1_D0_out), 
		.IO_SDC1_D1_in(IO_SDC1_D1_in), 
		.IO_SDC1_D1_out(IO_SDC1_D1_out), 
		.IO_SDC1_D2_in(IO_SDC1_D2_in), 
		.IO_SDC1_D2_out(IO_SDC1_D2_out), 
		.IO_SDC1_D3_in(IO_SDC1_D3_in), 
		.IO_SDC1_D3_out(IO_SDC1_D3_out), 
		.IO_SDC1_CLK(IO_SDC1_CLK), 
		.IO_SDC1_CMD_in(IO_SDC1_CMD_in), 
		.IO_SDC1_CMD_out(IO_SDC1_CMD_out)
	);

	initial begin
		// Initialize Inputs
		clk                     = 0;
		reset                   = 1;
		man_init_sdc_strb       = 0;
		host_tst_cmd_strb       = 0;
		rd_reg_indx_puc         = 0;
		wr_reg_man              = 0;
		wreg_sdc_hc_reg_man     = 0;
		start_data_tf_strb      = 0;
		data_in_strb            = 0;
		last_set_of_data_strb   = 0;
		data                    = 0;
		wr_b_strb               = 0;
		fifo_data               = 0;
		sdc_rd_addr             = 0;
		sdc_wr_addr             = 0;
		tf_mode                 = 0;
      //sdc_cmd_indx            = 0;
		IO_SDC1_CD_WP           = 0;
		IO_SDC1_D0_in           = 1;
		IO_SDC1_D1_in           = 1;
		IO_SDC1_D2_in           = 1;
		IO_SDC1_D3_in           = 1;
		IO_SDC1_CMD_in          = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
   
   always #10 clk = ~clk; /* 20 ns period, 50 MHz clock */	 
   
	initial begin					 
		// 1000 ns (1 usec) later take out of reset
		#1000		reset						= 1'b0;											 
		// 1000 ns (1 usec) latch to register the manual write from the puc.
		#1025		wr_reg_man				= 1'b1;	         // writting to 0x0014 will activate this strobe also				  								  
					wreg_sdc_hc_reg_man	= 36'h000040002;  // write reg. manually from puc (0x0014)
		#200		wr_reg_man				= 1'b0;									  				  
		// Read back Block Size Regiser (004h)
		#2000		rd_reg_indx_puc		= 12'h004;	      // puc command 0x0013												 
		// Turn on the sdc clock.
		#1025		wr_reg_man				= 1'b1;					  								  
					wreg_sdc_hc_reg_man	= 36'h0002C4005;
		#200		wr_reg_man				= 1'b0;						  				  
		// Set on host_tst_cmd_strb to start a command send.
		#20000	host_tst_cmd_strb		= 1'b1;		      // This is for io register 0x0011.			  								  
					data						= 36'h00000081A;  // This is for sdc command 0x008		 
		#20		host_tst_cmd_strb		= 1'b0; 					  								  
		//#80		data						= 36'h00000081A;		  								  
		//#80		data						= 36'h0FF80291A;
		// Response from SD Card for CMD8.
      // Clock is 400 kHz.
		//-------------------------------------  
		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		8
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth	
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		1
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		a
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh	a
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		1
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		3
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------						  				  
		// Start the initialization process manually.
		//#2000	man_init_sdc_strb		= 1'b1;					 
//		#20		man_init_sdc_strb		= 1'b0;
//		// Response from SD Card for cmd08.
//		//-------------------------------------  
//		#300000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		8
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth	
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		1
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		a
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh	a
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		1
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		3
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------						
//		// Response from SD Card for cmd55.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		7
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth	
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		1
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		2
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		1
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		3
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------								
//		// Response from SD Card for acmd41.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth	
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		8
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		0
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------							
//		// Response from SD Card for cmd55.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		7
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth	
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		1
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		2
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		1
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		3
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------							
//		// Response from SD Card for acmd41.  First attempt.
//		// Keep sending acmd41 to check for busy signal.
//		// If Busy bit is set to one, the sd card has completed
//		// its initialization process.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// Still busy if 0.
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth	
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		8
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		0
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------						
//		// Response from SD Card for cmd55.
//		//-------------------------------------  
//		#20200000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560			IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560			IO_SDC1_CMD_in		= 1'b1; 	// third		3	
//		#2560			IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560			IO_SDC1_CMD_in		= 1'b0;	// fifth		7
//		#2560			IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560			IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560			IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560			IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560			IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560			IO_SDC1_CMD_in		= 1'b0; 	// third	   
//		#2560			IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth	
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		1
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		2
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		1
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		3
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------						
//		// Response from SD Card for acmd41.  Second attempt.
//		// Keep sending acmd41 to check for busy signal.
//		// If Busy bit is set to one, the sd card has completed
//		// its initialization process.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// Still busy if 0.
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth	
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		8
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		0
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------					
//		// Response from SD Card for cmd55.
//		//-------------------------------------  
//		#20200000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		7
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth	
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		1
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		2
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		1
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		3
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------				
//		// Response from SD Card for acmd41.  Third attempt.
//		// Keep sending acmd41 to check for busy signal.
//		// If Busy bit is set to one, the sd card has completed
//		// its initialization process.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// Still busy if 0.
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth	
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		8
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		0
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------					
//		// Response from SD Card for cmd55.
//		//-------------------------------------  
//		#20200000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		7
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth	
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		1
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		2
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		1
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		3
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------					
//		// Response from SD Card for acmd41.  Fourth attempt.
//		// Keep sending acmd41 to check for busy signal.
//		// If Busy bit is set to one, the sd card has completed
//		// its initialization process.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// Still busy if 0.
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth	
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		8
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		0
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------					
//		// Response from SD Card for cmd55.
//		//-------------------------------------  
//		#20200000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		7
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth	
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		1
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		2
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		1
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		3
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------					
//		// Response from SD Card for acmd41.  Fifth attempt.
//		// Keep sending acmd41 to check for busy signal.
//		// If Busy bit is set to one, the sd card has completed
//		// its initialization process.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// Still busy if 0.
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth	
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		8
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		0
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------			
//		// Response from SD Card for cmd55.
//		//-------------------------------------  
//		#20200000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		7
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth	
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		1
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		2
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		1
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		3
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------					
//		// Response from SD Card for acmd41.  Sixth attempt.
//		// Keep sending acmd41 to check for busy signal.
//		// If Busy bit is set to one, the sd card has completed
//		// its initialization process.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// Still busy if 0.
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth	
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		8
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		0
//		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
//		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
//		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
//		//-------------------------------------
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
//		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------		
//		-------------------------------------	
//		-------------------------------------	
//		-------------------------------------	
//		-------------------------------------				  				  
		// Start the initialization process manually.
		#15000000	man_init_sdc_strb		= 1'b1;					 
		#20			man_init_sdc_strb		= 1'b0;	// The clock is 20 ns per period.
		// Response from SD Card for cmd08.             
		//-------------------------------------  
		#300000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		8
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth	
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		1
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		a
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh	a
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		1
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		3
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------						
		// Response from SD Card for cmd55.
		//-------------------------------------  
		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		7
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth	
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		1
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		2
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		1
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		3
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth   
		//-------------------------------------								
		// Response from SD Card for acmd41.  Just to get OCR.
		//-------------------------------------  
		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth	
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		8
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		0
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------							
		// Response from SD Card for cmd55.
		//-------------------------------------  
		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		7
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth	
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		1
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		2
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		1
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		3
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------							
		// Response from SD Card for acmd41.  First attempt.
		// Keep sending acmd41 to check for busy signal.
		// If Busy bit is set to one, the sd card has completed
		// its initialization process.
		//-------------------------------------  
		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// Still busy if 0.
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth	
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		8
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		0
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------	
		// Response from SD Card for cmd55.
		//-------------------------------------  
		#20200000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560			IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560			IO_SDC1_CMD_in		= 1'b1; 	// third		3	
		#2560			IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560			IO_SDC1_CMD_in		= 1'b0;	// fifth		7
		#2560			IO_SDC1_CMD_in		= 1'b1;	// sixth
		#2560			IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560			IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560			IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560			IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560			IO_SDC1_CMD_in		= 1'b0; 	// third	   
		#2560			IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth	
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		1
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		2
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		1
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		3
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------						
		// Response from SD Card for acmd41.  Second attempt.
		// Keep sending acmd41 to check for busy signal.
		// If Busy bit is set to one, the sd card has completed
		// its initialization process.
		//-------------------------------------  
		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// Still busy if 0.
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth	
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		8
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		0
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------				
		// Response from SD Card for cmd55.
		//-------------------------------------  
		#20200000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		7
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth	
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		1
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		2
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		1
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		3
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------				
		// Response from SD Card for acmd41.  Third attempt.
		// Keep sending acmd41 to check for busy signal.
		// If Busy bit is set to one, the sd card has completed
		// its initialization process.
		//-------------------------------------  
		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// Still busy if 0.
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// 1 for sdhc or sdxc	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth	
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		8
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		0
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------					
		// Response from SD Card for cmd2, cid.
		//-------------------------------------  
		#250000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// Still busy if 0.
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// 1 for sdhc or sdxc	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth	
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		8
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		0
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// Still busy if 0.
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// 1 for sdhc or sdxc	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth	
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		8
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		0
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------		
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth	
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		8
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		0
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------		
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------				
		// Response from SD Card for cmd3
		//-------------------------------------  
		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		3	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// Still busy if 0.
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// 1 for sdhc or sdxc	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third	   
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// third		F
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth	
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// sixth		F
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		8
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth		0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		0
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b0;	// seventh	0
		#2560		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#2560		IO_SDC1_CMD_in		= 1'b0; 	// third		
		#2560		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#2560		IO_SDC1_CMD_in		= 1'b0;	// fifth		
		#2560		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#2560		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#2560		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------						  				  
		// Set transfer mode for multiple blocks write.		
      // Need to write to register 0x0018 in the io fpga
      // to set tf_mode.
		// 0x0018   0x0000C0025 transfer mode, writing multiple blocks
		#20000	tf_mode		      = 36'h0000C0025;					  					  
		// Set on host_tst_cmd_strb to start a command send.		  				  
		// Set on host_tst_cmd_strb is started by writing 0x0011
		// command in the PUC.
		// Send command 7 to go to the transfer state.
		// Previous command 3 sent us to the stand-by state.
		//
		#20000	host_tst_cmd_strb		= 1'b1;					  								  
					data						= 36'h000000700;		 
		#20		host_tst_cmd_strb		= 1'b0;		
		// Response from SD Card for CMD7.
      // Clock is about 1 MHz.
		//-------------------------------------  
		#300000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		
		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// fifth		7
		#640		IO_SDC1_CMD_in		= 1'b1;	// sixth
		#640		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#640		IO_SDC1_CMD_in		= 1'b0; 	// third	   
		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#640		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#640		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#640		IO_SDC1_CMD_in		= 1'b0; 	// third
		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth	
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#640		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#640		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		
		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// fifth
		#640		IO_SDC1_CMD_in		= 1'b0;	// sixth		1
		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh	
		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b1; 	// first bit of response
		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#640		IO_SDC1_CMD_in		= 1'b1; 	// third		a
		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b1;	// fifth
		#640		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#640		IO_SDC1_CMD_in		= 1'b1;	// seventh	a
		#640		IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		1
		#640		IO_SDC1_CMD_in		= 1'b1; 	// fourth
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// fifth		3
		#640		IO_SDC1_CMD_in		= 1'b0;	// sixth
		#640		IO_SDC1_CMD_in		= 1'b1;	// seventh
		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
		//-------------------------------------	
		// Start to send the data to the sd card.
		#200000	start_data_tf_strb	= 1'b1;	
					sdc_wr_addr				= 32'h00808000;	// sd card write location				 
		#20		start_data_tf_strb	= 1'b0;	
		// Response from SD Card for CMD25.
		//-------------------------------------  
		#50000	IO_SDC1_CMD_in		= 1'b0; 	// start bit
		#640		IO_SDC1_CMD_in		= 1'b0; 	// transmission bit	
		#640		IO_SDC1_CMD_in		= 1'b0; 	// start of command index		
		#640		IO_SDC1_CMD_in		= 1'b1; 	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b1;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0; 	// start of card status response
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b1;	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		IO_SDC1_CMD_in		= 1'b1; 	// 	
		#640		IO_SDC1_CMD_in		= 1'b1; 	// 
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 	
		#640		IO_SDC1_CMD_in		= 1'b1;	// ready_for_data
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0; 	// CRC next 7 bits
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	1
		#640		IO_SDC1_CMD_in		= 1'b1; 	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// 	3
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b1;	// 
		#640		IO_SDC1_CMD_in		= 1'b1;	// end bit
		//-------------------------------------								  				  
		// Fill up the fifo from PUC.
		#2000	  	wr_b_strb			= 1'b1;					  								  
					fifo_data		   = 64'hF123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA223456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'h0121456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'h0124456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'h012F456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'h0123A567A9ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'h012C456779ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'h012B456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'h012A456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'hA123456789ABCDEF;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;					  								  
					fifo_data			= 64'h0123456789FBCDEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 65th address					  								  
					fifo_data			= 64'h1133856489FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 66th address					  								  
					fifo_data			= 64'h1133852489FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 67th address					  								  
					fifo_data			= 64'h1130016489FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 68th address					  								  
					fifo_data			= 64'h1133850089FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 69th address					  								  
					fifo_data			= 64'h1133016489FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 70th address					  								  
					fifo_data			= 64'h1133456089CBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 71st address					  								  
					fifo_data			= 64'h1133851489FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 72nd address					  								  
					fifo_data			= 64'h1133851489FDADEF;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 73rd address					  								  
					fifo_data			= 64'h1133851480FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 74th address					  								  
					fifo_data			= 64'h5633851489FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 75th address					  								  
					fifo_data			= 64'h1133851589FBADEA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 76th address					  								  
					fifo_data			= 64'h1133851489FCADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 77th address					  								  
					fifo_data			= 64'h5433851489FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 78th address					  								  
					fifo_data			= 64'h1133851489F4ADEA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 79th address					  								  
					fifo_data			= 64'h1133851489FBACEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 80th address					  								  
					fifo_data			= 64'h1133851189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 81st address					  								  
					fifo_data			= 64'h1133851189ABADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 82nd address					  								  
					fifo_data			= 64'h113385118AFBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 83rd address					  								  
					fifo_data			= 64'h1133851100FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 84th address					  								  
					fifo_data			= 64'h1133851145FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 85th address					  								  
					fifo_data			= 64'h1133951184FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 86th address					  								  
					fifo_data			= 64'h1133851181FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 87th address					  								  
					fifo_data			= 64'h1137851189FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 88th address					  								  
					fifo_data			= 64'h1133851189F7ADE8;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 89th address					  								  
					fifo_data			= 64'h1133851089FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 90th address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 91st address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 92nd address					  								  
					fifo_data			= 64'h1133551184FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 93rd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 94th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 95th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 96th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 97th address					  								  
					fifo_data			= 64'h1133551189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 98th address					  								  
					fifo_data			= 64'h1133551189FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 99th address					  								  
					fifo_data			= 64'h1134551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 100th address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 101st address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 102nd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 103rd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 104th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 105th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 106th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 107th address					  								  
					fifo_data			= 64'h1133551189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 108th address					  								  
					fifo_data			= 64'h1133551189FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 109th address					  								  
					fifo_data			= 64'h1134551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 110th address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 111th address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 112th address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 113rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 114th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 115th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 116th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 117th address					  								  
					fifo_data			= 64'h1133551189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 118th address					  								  
					fifo_data			= 64'h1133551189FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 119th address					  								  
					fifo_data			= 64'h1134551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 120th address					  								  
					fifo_data			= 64'h1133551289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 121st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 122nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 123rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 124th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 125th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 126th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 127th address					  								  
					fifo_data			= 64'h1133551189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 128th address					  								  
					fifo_data			= 64'h1133551189FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 129th address					  								  
					fifo_data			= 64'h1134551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 130th address					  								  
					fifo_data			= 64'h1133551289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 131st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 132nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 133rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 134th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 135th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 136th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 137th address					  								  
					fifo_data			= 64'h1133551189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 138th address					  								  
					fifo_data			= 64'h1133551189FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 139th address					  								  
					fifo_data			= 64'h1134551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 140th address					  								  
					fifo_data			= 64'h1133551289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 141st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 142nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 143rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 144th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 145th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 146th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 147th address					  								  
					fifo_data			= 64'h1133551189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 148th address					  								  
					fifo_data			= 64'h1133551189FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 149th address					  								  
					fifo_data			= 64'h1134551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 150th address					  								  
					fifo_data			= 64'h1133551289FBA5EA;
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 151st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 152nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 153rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 154th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 155th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 156th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 157th address					  								  
					fifo_data			= 64'h1133551189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 158th address					  								  
					fifo_data			= 64'h1133551189FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 159th address					  								  
					fifo_data			= 64'h1134551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 160th address					  								  
					fifo_data			= 64'h1133551289FBA5EA;				 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 161st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 162nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 163rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 164th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 165th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 166th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 167th address					  								  
					fifo_data			= 64'h1133551189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 168th address					  								  
					fifo_data			= 64'h1133551189FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 169th address					  								  
					fifo_data			= 64'h1134551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 170th address					  								  
					fifo_data			= 64'h1133551289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 171st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 172nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 173rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 174th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 175th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 176th address					  								  
					fifo_data			= 64'h1123551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 177th address					  								  
					fifo_data			= 64'h1133551289FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 178th address					  								  
					fifo_data			= 64'h1133551089FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 179th address					  								  
					fifo_data			= 64'h1134551089FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 180th address					  								  
					fifo_data			= 64'h1133551589FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 181st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 182nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 183rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 184th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 185th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 186th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 187th address					  								  
					fifo_data			= 64'h1133551189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 188th address					  								  
					fifo_data			= 64'h1133551189FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 189th address					  								  
					fifo_data			= 64'h1134551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 190th address					  								  
					fifo_data			= 64'h1133551289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 191st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 192nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 193rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 194th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 195th address					  								  
					fifo_data			= 64'h11335511491BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 196th address					  								  
					fifo_data			= 64'h1133551159FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 197th address					  								  
					fifo_data			= 64'h1133551489FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 198th address					  								  
					fifo_data			= 64'h1133551389FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 199th address					  								  
					fifo_data			= 64'h1134551489FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 200th address					  								  
					fifo_data			= 64'h1133551389FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 201st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 202nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 203rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 204th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 205th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 206th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 207th address					  								  
					fifo_data			= 64'h1133551189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 208th address					  								  
					fifo_data			= 64'h1133551189FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 209th address					  								  
					fifo_data			= 64'h1134551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 210th address					  								  
					fifo_data			= 64'h1133551289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 211th address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 212th address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 213th address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 214th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 215th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 216th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 217th address					  								  
					fifo_data			= 64'h1133551189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 218th address					  								  
					fifo_data			= 64'h1133551189FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 219th address					  								  
					fifo_data			= 64'h1134551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 220th address					  								  
					fifo_data			= 64'h1133551289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 221st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 222nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 223rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 224th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 225th address					  								  
					fifo_data			= 64'h113355118914ADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 226th address					  								  
					fifo_data			= 64'h1133551189F34DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 227th address					  								  
					fifo_data			= 64'h1133551189F1AD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 228th address					  								  
					fifo_data			= 64'h1133551149FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 229th address					  								  
					fifo_data			= 64'h1134551129FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 230th address					  								  
					fifo_data			= 64'h1133551219FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 231st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 232nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 233rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 234th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 235th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 236th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 237th address					  								  
					fifo_data			= 64'h1133551189FBA45A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 238th address					  								  
					fifo_data			= 64'h1133551489FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 239th address					  								  
					fifo_data			= 64'h1134552489FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 240th address					  								  
					fifo_data			= 64'h1133551489FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 241st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 242nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 243rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 244th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 245th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 246th address					  								  
					fifo_data			= 64'h1133551189FB5DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 247th address					  								  
					fifo_data			= 64'h1133551189F00D5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 248th address					  								  
					fifo_data			= 64'h1103551189FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 249th address					  								  
					fifo_data			= 64'h1134551089FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 250th address					  								  
					fifo_data			= 64'h1133551689FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 251st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 252nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 253rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 254th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 255th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 256th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 257th address					  								  
					fifo_data			= 64'h1133551189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 258th address					  								  
					fifo_data			= 64'h1133551189FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 259th address					  								  
					fifo_data			= 64'h1134551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 260th address					  								  
					fifo_data			= 64'h1133551289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 261st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 262nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 263rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 264th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 265th address					  								  
					fifo_data			= 64'h11333611891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 266th address					  								  
					fifo_data			= 64'h1133561189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 267th address					  								  
					fifo_data			= 64'h1133500189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 268th address					  								  
					fifo_data			= 64'h1133551189F56DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 269th address					  								  
					fifo_data			= 64'h1134551689FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 270th address					  								  
					fifo_data			= 64'h1133551589FBA5EA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 271st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 272nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 273rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 274th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 275th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 276th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 277th address					  								  
					fifo_data			= 64'h1133F51189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 278th address					  								  
					fifo_data			= 64'h113E551189FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 279th address					  								  
					fifo_data			= 64'h113B551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 280th address					  								  
					fifo_data			= 64'h11335A1289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 281st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 282nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 283rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 284th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 285th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 286th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 287th address					  								  
					fifo_data			= 64'h113355E189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 288th address					  								  
					fifo_data			= 64'h1133A51189FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 289th address					  								  
					fifo_data			= 64'h113455C189FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 290th address					  								  
					fifo_data			= 64'h1133551A89FBA5EA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 291st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 292nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 293rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 294th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 295th address					  								  
					fifo_data			= 64'h113A5511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 296th address					  								  
					fifo_data			= 64'h1133D51189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 297th address					  								  
					fifo_data			= 64'h1133C51189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 298th address					  								  
					fifo_data			= 64'h1133B51189FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 299th address					  								  
					fifo_data			= 64'h113A551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 300th address					  								  
					fifo_data			= 64'h1134551289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 301st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 302nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 303rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 304th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 305th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 306th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 307th address					  								  
					fifo_data			= 64'h1133551189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 308th address					  								  
					fifo_data			= 64'h1133551139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 309th address					  								  
					fifo_data			= 64'h1134551289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 310th address					  								  
					fifo_data			= 64'h1133554289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 311th address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 312nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 313th address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 314th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 315th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 316th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 317th address					  								  
					fifo_data			= 64'h1133A51189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 318th address					  								  
					fifo_data			= 64'h1131551139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 319th address					  								  
					fifo_data			= 64'h1131551289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 320th address					  								  
					fifo_data			= 64'h1133554489FBA5EA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 321st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 322nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 323rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 324th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 325th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 326th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 327th address					  								  
					fifo_data			= 64'h1133551189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 328th address					  								  
					fifo_data			= 64'h1133551F39FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 329th address					  								  
					fifo_data			= 64'h113455AE89FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 330th address					  								  
					fifo_data			= 64'h1133554289FAA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 331st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 332nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 333rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 334th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 335th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 336th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 337th address					  								  
					fifo_data			= 64'h1133551B89FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 338th address					  								  
					fifo_data			= 64'h1133551A39FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 339th address					  								  
					fifo_data			= 64'h1134551389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 340th address					  								  
					fifo_data			= 64'h1133554489FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 341st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 342nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 343rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 344th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 345th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 346th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 347th address					  								  
					fifo_data			= 64'h1133551E89FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 348th address					  								  
					fifo_data			= 64'h1133551C39FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 349th address					  								  
					fifo_data			= 64'h1134551B89FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 350th address					  								  
					fifo_data			= 64'h1133554A89FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 351st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 352nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 353rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 354th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 355th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 356th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 357th address					  								  
					fifo_data			= 64'h1133551D89FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 358th address					  								  
					fifo_data			= 64'h1133551C39FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 359th address					  								  
					fifo_data			= 64'h1134551B89FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 360th address					  								  
					fifo_data			= 64'h1133554A89FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 361st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 362nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 363rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 364th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 365th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 366th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 367th address					  								  
					fifo_data			= 64'h1133551189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 368th address					  								  
					fifo_data			= 64'h1133551139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 369th address					  								  
					fifo_data			= 64'h1134551289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 370th address					  								  
					fifo_data			= 64'h1133554289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 371st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 372nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 373rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 374th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 375th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 376th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 377th address					  								  
					fifo_data			= 64'h1133551D89FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 378th address					  								  
					fifo_data			= 64'h1133551C39FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 379th address					  								  
					fifo_data			= 64'h1134551B89FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 380th address					  								  
					fifo_data			= 64'h1133554A89FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 381st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 382nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 383rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 384th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 385th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 386th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 387th address					  								  
					fifo_data			= 64'h113355D189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 388th address					  								  
					fifo_data			= 64'h11335511C9FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 389th address					  								  
					fifo_data			= 64'h11345512B9FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 390th address					  								  
					fifo_data			= 64'h11335542A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 391st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 392nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 393rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 394th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 395th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 396th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 397th address					  								  
					fifo_data			= 64'h1133551D89FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 398th address					  								  
					fifo_data			= 64'h1133551C39FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 399th address					  								  
					fifo_data			= 64'h1134551B89FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 400th address					  								  
					fifo_data			= 64'h1133554A89FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 401st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 402nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 403rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 404th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 405th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 406th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 407th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 408th address					  								  
					fifo_data			= 64'h113355C139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 409th address					  								  
					fifo_data			= 64'h113455B289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 410th address					  								  
					fifo_data			= 64'h113355A289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 411st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 412nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 413th address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 414th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 415th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 416th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 417th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 418th address					  								  
					fifo_data			= 64'h113355C139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 419th address					  								  
					fifo_data			= 64'h113455B289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 420th address					  								  
					fifo_data			= 64'h113355A289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;				
		#2000	   wr_b_strb			= 1'b1;  // 421st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 422nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 423rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 424th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 425th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 426th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 427th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 428th address					  								  
					fifo_data			= 64'h11C355C139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 429th address					  								  
					fifo_data			= 64'h1B3455B289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 430th address					  								  
					fifo_data			= 64'h1A3355A289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 431st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 432nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 433rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 434th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 435th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 436th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 437th address					  								  
					fifo_data			= 64'h11335D1D89FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 438th address					  								  
					fifo_data			= 64'h113355CC39FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 439th address					  								  
					fifo_data			= 64'h113455BB89FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 440th address					  								  
					fifo_data			= 64'h113355AA89FBA5EA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 441st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 442nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 443rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 444th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 445th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 446th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 447th address					  								  
					fifo_data			= 64'h11335D1D89FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 448th address					  								  
					fifo_data			= 64'h113355CC39FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 449th address					  								  
					fifo_data			= 64'h113455BB89FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 450th address					  								  
					fifo_data			= 64'h113355AA89FBA5EA;		 
		#20		wr_b_strb			= 1'b0;				
		#2000	   wr_b_strb			= 1'b1;  // 451st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 452nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 453rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 454th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 455th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 456th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 457th address					  								  
					fifo_data			= 64'h11335D1D89FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 458th address					  								  
					fifo_data			= 64'h113355CC39FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 459th address					  								  
					fifo_data			= 64'h113455BB89FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 460th address					  								  
					fifo_data			= 64'h113355AA89FBA5EA;		 
		#20		wr_b_strb			= 1'b0;				
		#2000	   wr_b_strb			= 1'b1;  // 461st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 462nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 463rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 464th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 465th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 466th address					  								  
					fifo_data			= 64'h1133551D89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 467th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 468th address					  								  
					fifo_data			= 64'h113355CC39FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 469th address					  								  
					fifo_data			= 64'h113455BB89FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 470th address					  								  
					fifo_data			= 64'h113355AA89FBA5EA;		 
		#20		wr_b_strb			= 1'b0;				
		#2000	   wr_b_strb			= 1'b1;  // 471st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 472nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 473rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 474th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 475th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 476th address					  								  
					fifo_data			= 64'h1133551D89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 477th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 478th address					  								  
					fifo_data			= 64'h113355CD39FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 479th address					  								  
					fifo_data			= 64'h113455BB89FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 480th address					  								  
					fifo_data			= 64'h113355AA89FBA5EA;		 
		#20		wr_b_strb			= 1'b0;				
		#2000	   wr_b_strb			= 1'b1;  // 481st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 482nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 483rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 484th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 485th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 486th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 487th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 488th address					  								  
					fifo_data			= 64'h113355CE39FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 489th address					  								  
					fifo_data			= 64'h113455BE89FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 490th address					  								  
					fifo_data			= 64'h113355AB89FBA5EA;		 
		#20		wr_b_strb			= 1'b0;				
		#2000	   wr_b_strb			= 1'b1;  // 491st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 492nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 493rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 494th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 495th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 496th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 497th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 498th address					  								  
					fifo_data			= 64'h313355C139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 499th address					  								  
					fifo_data			= 64'h1A3455B289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 500th address					  								  
					fifo_data			= 64'h113355AB89FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 501st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 502nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 503rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 504th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 505th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 506th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 507th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 508th address					  								  
					fifo_data			= 64'h1133C5C139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 509th address					  								  
					fifo_data			= 64'h1134B5B289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 510th address					  								  
					fifo_data			= 64'h1133A5A289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 511th address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 512th address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 513th address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 514th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 515th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 516th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 517th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 518th address					  								  
					fifo_data			= 64'h1133C5C139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 519th address					  								  
					fifo_data			= 64'h1134B5B289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 520th address					  								  
					fifo_data			= 64'h1133A5A289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 521st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 522nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 523rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 524th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 525th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 526th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 527th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 528th address					  								  
					fifo_data			= 64'h1133C5C239FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 529th address					  								  
					fifo_data			= 64'h1134B5B389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 530th address					  								  
					fifo_data			= 64'h1133A5A189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 531st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 532nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 533rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 534th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 535th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 536th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 537th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 538th address					  								  
					fifo_data			= 64'h1133C1C239FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 539th address					  								  
					fifo_data			= 64'h1134B1B389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 540th address					  								  
					fifo_data			= 64'h1123A5A189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 541st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 542nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 543rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 544th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 545th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 546th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 547th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 548th address					  								  
					fifo_data			= 64'h1133C1C239FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 549th address					  								  
					fifo_data			= 64'h1134BBB389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 550th address					  								  
					fifo_data			= 64'h1123A5A1A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 551st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 552nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 553rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 554th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 555th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 556th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 557th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 558th address					  								  
					fifo_data			= 64'h1133C1C239FB6D0A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 559th address					  								  
					fifo_data			= 64'h8134BBB389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 560th address					  								  
					fifo_data			= 64'h1173A5A1A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 561st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 562nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 563rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 564th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 565th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 566th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 567th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 568th address					  								  
					fifo_data			= 64'h11C3C1C239FB6D0A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 569th address					  								  
					fifo_data			= 64'h8B34BBB389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 570th address					  								  
					fifo_data			= 64'h117AA5A1A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 571st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 572nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 573rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 574th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 575th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 576th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 577th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 578th address					  								  
					fifo_data			= 64'h11C3C1C299FB6D0A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 579th address					  								  
					fifo_data			= 64'h8B34BBB359FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 580th address					  								  
					fifo_data			= 64'h117AA5A0A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 581st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 582nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 583rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 584th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 585th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 586th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 587th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 588th address					  								  
					fifo_data			= 64'h11C3C1C299FB680A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 589th address					  								  
					fifo_data			= 64'h8534BBB359FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 590th address					  								  
					fifo_data			= 64'h127AA5A0A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 591st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 592nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 593rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 594th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 595th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 596th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 597th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 598th address					  								  
					fifo_data			= 64'h11C3C1C799FB680A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 599th address					  								  
					fifo_data			= 64'h8534BBB659FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 600th address					  								  
					fifo_data			= 64'h127AA5A5A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 601st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 602nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 603rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 604th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 605th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 606th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 607th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 608th address					  								  
					fifo_data			= 64'h1133C5C139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 609th address					  								  
					fifo_data			= 64'h1134B5B289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 610th address					  								  
					fifo_data			= 64'h1133A5A289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 611th address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 612th address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 613th address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 614th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 615th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 616th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 617th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 618th address					  								  
					fifo_data			= 64'h1133C5C139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 619th address					  								  
					fifo_data			= 64'h1134B5B289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 620th address					  								  
					fifo_data			= 64'h1133A5A289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 621st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 622nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 623rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 624th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 625th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 626th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 627th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 628th address					  								  
					fifo_data			= 64'h1133C5C239FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 629th address					  								  
					fifo_data			= 64'h1134B5B389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 630th address					  								  
					fifo_data			= 64'h1133A5A189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 631st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 632nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 633rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 634th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 635th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 636th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 637th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 638th address					  								  
					fifo_data			= 64'h1133C1C239FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 639th address					  								  
					fifo_data			= 64'h1134B1B389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 640th address					  								  
					fifo_data			= 64'h1123A5A189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 641st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 642nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 643rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 644th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 645th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 646th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 647th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 648th address					  								  
					fifo_data			= 64'h1133C1C239FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 649th address					  								  
					fifo_data			= 64'h1134BBB389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 650th address					  								  
					fifo_data			= 64'h1123A5A1A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 651st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 652nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 653rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 654th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 655th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 656th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 657th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 658th address					  								  
					fifo_data			= 64'h1133C1C239FB6D0A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 659th address					  								  
					fifo_data			= 64'h8134BBB389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 660th address					  								  
					fifo_data			= 64'h1173A5A1A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 661st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 662nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 663rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 664th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 665th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 666th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 667th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 668th address					  								  
					fifo_data			= 64'h11C3C1C239FB6D0A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 669th address					  								  
					fifo_data			= 64'h8B34BBB389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 670th address					  								  
					fifo_data			= 64'h117AA5A1A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 671st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 672nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 673rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 674th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 675th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 676th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 677th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 678th address					  								  
					fifo_data			= 64'h11C3C1C299FB6D0A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 679th address					  								  
					fifo_data			= 64'h8B34BBB359FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 680th address					  								  
					fifo_data			= 64'h117AA5A0A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 681st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 682nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 683rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 684th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 685th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 686th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 687th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 688th address					  								  
					fifo_data			= 64'h11C3C1C299FB680A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 689th address					  								  
					fifo_data			= 64'h8534BBB359FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 690th address					  								  
					fifo_data			= 64'h127AA5A0A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 691st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 692nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 693rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 694th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 695th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 696th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 697th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 698th address					  								  
					fifo_data			= 64'h11C3C1C799FB680A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 699th address					  								  
					fifo_data			= 64'h8534BBB659FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 700th address					  								  
					fifo_data			= 64'h127AA5A5A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 701st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 702nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 703rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 704th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 705th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 706th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 707th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 708th address					  								  
					fifo_data			= 64'h1133C5C139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 709th address					  								  
					fifo_data			= 64'h1134B5B289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 710th address					  								  
					fifo_data			= 64'h1133A5A289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 711th address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 712th address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 713th address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 714th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 715th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 716th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 717th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 718th address					  								  
					fifo_data			= 64'h1133C5C139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 719th address					  								  
					fifo_data			= 64'h1134B5B289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 720th address					  								  
					fifo_data			= 64'h1133A5A289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 721st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 722nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 723rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 724th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 725th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 626th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 727th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 728th address					  								  
					fifo_data			= 64'h1133C5C239FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 729th address					  								  
					fifo_data			= 64'h1134B5B389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 730th address					  								  
					fifo_data			= 64'h1133A5A189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 731st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 732nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 733rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 734th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 735th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 736th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 737th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 738th address					  								  
					fifo_data			= 64'h1133C1C239FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 739th address					  								  
					fifo_data			= 64'h1134B1B389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 740th address					  								  
					fifo_data			= 64'h1123A5A189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 741st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 742nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 743rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 744th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 745th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 746th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 747th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 748th address					  								  
					fifo_data			= 64'h1133C1C239FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 749th address					  								  
					fifo_data			= 64'h1134BBB389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 750th address					  								  
					fifo_data			= 64'h1123A5A1A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 751st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 752nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 753rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 754th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 755th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 756th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 757th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 758th address					  								  
					fifo_data			= 64'h1133C1C239FB6D0A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 759th address					  								  
					fifo_data			= 64'h8134BBB389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 760th address					  								  
					fifo_data			= 64'h1173A5A1A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 761st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 762nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 763rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 764th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 765th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 766th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 767th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 768th address					  								  
					fifo_data			= 64'h11C3C1C239FB6D0A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 769th address					  								  
					fifo_data			= 64'h8B34BBB389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 770th address					  								  
					fifo_data			= 64'h117AA5A1A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 771st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 772nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 773rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 774th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 775th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 776th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 777th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 778th address					  								  
					fifo_data			= 64'h11C3C1C299FB6D0A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 779th address					  								  
					fifo_data			= 64'h8B34BBB359FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 780th address					  								  
					fifo_data			= 64'h117AA5A0A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 781st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 782nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 783rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 784th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 785th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 786th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 787th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 788th address					  								  
					fifo_data			= 64'h11C3C1C299FB680A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 789th address					  								  
					fifo_data			= 64'h8534BBB359FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 790th address					  								  
					fifo_data			= 64'h127AA5A0A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 791st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 792nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 793rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 794th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 795th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 796th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 797th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 798th address					  								  
					fifo_data			= 64'h11C3C1C799FB680A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 799th address					  								  
					fifo_data			= 64'h8534BBB659FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 800th address					  								  
					fifo_data			= 64'h127AA5A5A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 801st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 802nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 803rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 804th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 805th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 806th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 807th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 808th address					  								  
					fifo_data			= 64'h1133C5C139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 809th address					  								  
					fifo_data			= 64'h1134B5B289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 810th address					  								  
					fifo_data			= 64'h1133A5A289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 811th address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 812th address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 813th address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 814th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 815th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 816th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 817th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 818th address					  								  
					fifo_data			= 64'h1133C5C139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 819th address					  								  
					fifo_data			= 64'h1134B5B289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 820th address					  								  
					fifo_data			= 64'h1133A5A289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 821st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 822nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 823rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 824th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 825th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 826th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 827th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 828th address					  								  
					fifo_data			= 64'h1133C5C239FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 829th address					  								  
					fifo_data			= 64'h1134B5B389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 830th address					  								  
					fifo_data			= 64'h1133A5A189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 831st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 832nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 833rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 834th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 835th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 836th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 837th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 838th address					  								  
					fifo_data			= 64'h1133C1C239FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 839th address					  								  
					fifo_data			= 64'h1134B1B389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 840th address					  								  
					fifo_data			= 64'h1123A5A189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 841st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 842nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 843rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 844th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 845th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 846th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 847th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 848th address					  								  
					fifo_data			= 64'h1133C1C239FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 849th address					  								  
					fifo_data			= 64'h1134BBB389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 850th address					  								  
					fifo_data			= 64'h1123A5A1A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 851st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 852nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 853rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 854th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 855th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 856th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 857th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 858th address					  								  
					fifo_data			= 64'h1133C1C239FB6D0A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 859th address					  								  
					fifo_data			= 64'h8134BBB389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 860th address					  								  
					fifo_data			= 64'h1173A5A1A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 861st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 862nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 863rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 864th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 865th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 866th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 867th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 868th address					  								  
					fifo_data			= 64'h11C3C1C239FB6D0A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 869th address					  								  
					fifo_data			= 64'h8B34BBB389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 870th address					  								  
					fifo_data			= 64'h117AA5A1A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 871st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 872nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 873rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 874th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 875th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 876th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 877th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 878th address					  								  
					fifo_data			= 64'h11C3C1C299FB6D0A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 879th address					  								  
					fifo_data			= 64'h8B34BBB359FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 880th address					  								  
					fifo_data			= 64'h117AA5A0A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 881st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 882nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 883rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 884th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 885th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 886th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 887th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 888th address					  								  
					fifo_data			= 64'h11C3C1C299FB680A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 889th address					  								  
					fifo_data			= 64'h8534BBB359FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 890th address					  								  
					fifo_data			= 64'h127AA5A0A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 891st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 892nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 893rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 894th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 895th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 896th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 897th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 898th address					  								  
					fifo_data			= 64'h11C3C1C799FB680A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 899th address					  								  
					fifo_data			= 64'h8534BBB659FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 900th address					  								  
					fifo_data			= 64'h127AA5A5A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 901st address					  								  
					fifo_data			= 64'h1133551389FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 902nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 903rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 904th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 905th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 906th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 907th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 908th address					  								  
					fifo_data			= 64'h1133C5C139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 909th address					  								  
					fifo_data			= 64'h1134B5B289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 910th address					  								  
					fifo_data			= 64'h1133A5A289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 911th address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 912th address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 913th address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 914th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 915th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 916th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 917th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 918th address					  								  
					fifo_data			= 64'h1133C5C139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 919th address					  								  
					fifo_data			= 64'h1134B5B289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 920th address					  								  
					fifo_data			= 64'h1133A5A289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 921st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 922nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 923rd address					  								  
					fifo_data			= 64'h1133553180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 924th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 925th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 926th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 927th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 928th address					  								  
					fifo_data			= 64'h1133C5C239FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 929th address					  								  
					fifo_data			= 64'h1134B5B389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 930th address					  								  
					fifo_data			= 64'h1133A5A189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 931st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 932nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 933rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 934th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 935th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 936th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 937th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 938th address					  								  
					fifo_data			= 64'h1133C1C239FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 939th address					  								  
					fifo_data			= 64'h1134B1B389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 940th address					  								  
					fifo_data			= 64'h1123A5A189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 941st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 942nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 943rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 944th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 945th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 946th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 947th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 948th address					  								  
					fifo_data			= 64'h1133C1C239FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 949th address					  								  
					fifo_data			= 64'h1134BBB389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 950th address					  								  
					fifo_data			= 64'h1123A5A1A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 951st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 952nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 953rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 954th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 955th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 956th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 957th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 958th address					  								  
					fifo_data			= 64'h1133C1C239FB6D0A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 959th address					  								  
					fifo_data			= 64'h8134BBB389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 960th address					  								  
					fifo_data			= 64'h1173A5A1A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 961st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 962nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 963rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 964th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 965th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 966th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 967th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 968th address					  								  
					fifo_data			= 64'h11C3C1C239FB6D0A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 969th address					  								  
					fifo_data			= 64'h8B34BBB389FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 970th address					  								  
					fifo_data			= 64'h117AA5A1A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 971st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 972nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 973rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 974th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 975th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 976th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 977th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 978th address					  								  
					fifo_data			= 64'h11C3C1C299FB6D0A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 979th address					  								  
					fifo_data			= 64'h8B34BBB359FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 980th address					  								  
					fifo_data			= 64'h117AA5A0A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 981st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 982nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 983rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 984th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 985th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 986th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 987th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 988th address					  								  
					fifo_data			= 64'h11C3C1C299FB680A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 989th address					  								  
					fifo_data			= 64'h8534BBB359FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 990th address					  								  
					fifo_data			= 64'h127AA5A0A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 991st address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 992nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 993rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 994th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 995th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 996th address					  								  
					fifo_data			= 64'h1133551A89FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 997th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 998th address					  								  
					fifo_data			= 64'h11C3C1C799FB680A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 999th address					  								  
					fifo_data			= 64'h8534BBB659FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 1000th address					  								  
					fifo_data			= 64'h127AA5A5A9FBA5EA;		 
		#20		wr_b_strb			= 1'b0;					
		#2000	   wr_b_strb			= 1'b1;  // 1001st address					  								  
					fifo_data			= 64'h1133551389FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 1002nd address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 1003rd address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 1004th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 1005th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 1006th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 1007th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 1008th address					  								  
					fifo_data			= 64'h1133C5C139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 1009th address					  								  
					fifo_data			= 64'h1134B5B289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 1010th address					  								  
					fifo_data			= 64'h1133A5A289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 1011th address					  								  
					fifo_data			= 64'h1133551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 1012th address					  								  
					fifo_data			= 64'h1133551189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 1013th address					  								  
					fifo_data			= 64'h1133551180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 1014th address					  								  
					fifo_data			= 64'h1133151189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 1015th address					  								  
					fifo_data			= 64'h11335511891BADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 1016th address					  								  
					fifo_data			= 64'h1133551189FB4DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 1017th address					  								  
					fifo_data			= 64'h11335D1189FBAD5A;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 1018th address					  								  
					fifo_data			= 64'h1133C5C139FB6DEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 1019th address					  								  
					fifo_data			= 64'h1134B5B289FBADEA;		 
		#20		wr_b_strb			= 1'b0;	
		#2000	   wr_b_strb			= 1'b1;  // 1020th address					  								  
					fifo_data			= 64'h11A3A5A289FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 1021st address					  								  
					fifo_data			= 64'h11B3551189FBA5EA;		 
		#20		wr_b_strb			= 1'b0;			
		#2000	   wr_b_strb			= 1'b1;  // 1022nd address					  								  
					fifo_data			= 64'h11335A1189FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 1023rd address					  								  
					fifo_data			= 64'h11335A3180FBADEA;		 
		#20		wr_b_strb			= 1'b0;		
		#2000	   wr_b_strb			= 1'b1;  // 1024th address					  								  
					fifo_data			= 64'h1133151589FBADEA;		 
		#20		wr_b_strb			= 1'b0;						

//      for (i=0; i<WIDTH; i=i+1)
//         #2000	   wr_b_strb		= 1'b1; 
//         DATA[i] = 64'h1133551189FBADEA;
//         #20		wr_b_strb		= 1'b0;	  
		// Use the next sixteen writing blocks for 20 ms simulation.
      // Actual time used for writing blocks wait is 60 ms.
      // We use 20 ms to accelerate the simulation.
      // You need to change this wait time in the
      // adma2_fsm.v module for simulation or real integration.
		// Busy signal from sd card while it saves the data.
		// The card pulls down the D0 low to indicate it is busy.
      // This is for the first block of data.
		//-------------------------------------  
		#2700000	   IO_SDC1_D0_in		= 1'b0; 	//   
		#19000000   IO_SDC1_D0_in		= 1'b1; 	// 19 ms later			
		// Busy signal from sd card while it saves the data.
		// The card pulls down the D0 low to indicate it is busy.
      // This is for the second block of data.
		//-------------------------------------  
		#4000000	   IO_SDC1_D0_in		= 1'b0; 	// 4 ms later  
		#19000000   IO_SDC1_D0_in		= 1'b1; 	// 19 ms later			
		// Busy signal from sd card while it saves the data.
		// The card pulls down the D0 low to indicate it is busy.
      // This is for the third block of data.
		//-------------------------------------  
		#4000000	   IO_SDC1_D0_in		= 1'b0; 	//   
		#19000000   IO_SDC1_D0_in		= 1'b1; 	// 19 ms later			
		// Busy signal from sd card while it saves the data.
		// The card pulls down the D0 low to indicate it is busy.
      // This is for the fourth block of data.
		//-------------------------------------  
		#3500000	   IO_SDC1_D0_in		= 1'b0; 	//   
		#19000000   IO_SDC1_D0_in		= 1'b1; 	// 19 ms later			
		// Busy signal from sd card while it saves the data.
		// The card pulls down the D0 low to indicate it is busy.
      // This is for the fifth block of data.
		//-------------------------------------  
		#3500000	   IO_SDC1_D0_in		= 1'b0; 	//   
		#19000000   IO_SDC1_D0_in		= 1'b1; 	// 19 ms later			
		// Busy signal from sd card while it saves the data.
		// The card pulls down the D0 low to indicate it is busy.
      // This is for the sixth block of data.
		//-------------------------------------  
		#3500000	   IO_SDC1_D0_in		= 1'b0; 	//   
		#19000000   IO_SDC1_D0_in		= 1'b1; 	// 19 ms later			
		// Busy signal from sd card while it saves the data.
		// The card pulls down the D0 low to indicate it is busy.
      // This is for the seventh block of data.
		//-------------------------------------  
		#3500000	   IO_SDC1_D0_in		= 1'b0; 	//   
		#19000000   IO_SDC1_D0_in		= 1'b1; 	// 19 ms later			
		// Busy signal from sd card while it saves the data.
		// The card pulls down the D0 low to indicate it is busy.
      // This is for the eighth block of data.
		//-------------------------------------  
		#3500000	   IO_SDC1_D0_in		= 1'b0; 	//   
		#19000000   IO_SDC1_D0_in		= 1'b1; 	// 19 ms later			
		// Busy signal from sd card while it saves the data.
		// The card pulls down the D0 low to indicate it is busy.
      // This is for the ninth block of data.
		//-------------------------------------  
		#4000000	   IO_SDC1_D0_in		= 1'b0; 	//   
		#19000000   IO_SDC1_D0_in		= 1'b1; 	// 19 ms later			
		// Busy signal from sd card while it saves the data.
		// The card pulls down the D0 low to indicate it is busy.
      // This is for the tenth block of data.
		//-------------------------------------  
		#4000000	   IO_SDC1_D0_in		= 1'b0; 	//   
		#19000000   IO_SDC1_D0_in		= 1'b1; 	// 19 ms later			
		// Busy signal from sd card while it saves the data.
		// The card pulls down the D0 low to indicate it is busy.
      // This is for the eleventh block of data.
		//-------------------------------------  
		#3500000	   IO_SDC1_D0_in		= 1'b0; 	//   
		#19000000   IO_SDC1_D0_in		= 1'b1; 	// 19 ms later			
		// Busy signal from sd card while it saves the data.
		// The card pulls down the D0 low to indicate it is busy.
      // This is for the twelveth block of data.
		//-------------------------------------  
		#3500000	   IO_SDC1_D0_in		= 1'b0; 	//   
		#19000000   IO_SDC1_D0_in		= 1'b1; 	// 19 ms later			
		// Busy signal from sd card while it saves the data.
		// The card pulls down the D0 low to indicate it is busy.
      // This is for the thirteenth block of data.
		//-------------------------------------  
		#3500000	   IO_SDC1_D0_in		= 1'b0; 	//   
		#19000000   IO_SDC1_D0_in		= 1'b1; 	// 19 ms later			
		// Busy signal from sd card while it saves the data.
		// The card pulls down the D0 low to indicate it is busy.
      // This is for the fourteenth block of data.
		//-------------------------------------  
		#3500000	   IO_SDC1_D0_in		= 1'b0; 	//   
		#19000000   IO_SDC1_D0_in		= 1'b1; 	// 19 ms later			
		// Busy signal from sd card while it saves the data.
		// The card pulls down the D0 low to indicate it is busy.
      // This is for the fifteenth block of data.
		//-------------------------------------  
		#3500000	   IO_SDC1_D0_in		= 1'b0; 	//   
		#19000000   IO_SDC1_D0_in		= 1'b1; 	// 19 ms later			
		// Busy signal from sd card while it saves the data.
		// The card pulls down the D0 low to indicate it is busy.
      // This is for the sixteenth block of data.
		//-------------------------------------  
		#3500000	   IO_SDC1_D0_in		= 1'b0; 	//   
		#19000000   IO_SDC1_D0_in		= 1'b1; 	// 19 ms later
		// Response from SD Card for CMD12.
      // Wait for x amount of time after sending the
      // blocks of data, then send out cmd12.
		//-------------------------------------  
		#20000000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
		#640		   IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
		#640		   IO_SDC1_CMD_in		= 1'b0; 	// third		
		#640		   IO_SDC1_CMD_in		= 1'b0; 	// fourth
		//-------------------------------------
		#640		   IO_SDC1_CMD_in		= 1'b1;	// fifth		D
		#640		   IO_SDC1_CMD_in		= 1'b1;	// sixth
		#640		   IO_SDC1_CMD_in		= 1'b0;	// seventh
		#640		   IO_SDC1_CMD_in		= 1'b0;	// eigth
		//-------   ------------------------------
		#640		   IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		   IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		   IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		   IO_SDC1_CMD_in		= 1'b0; 	// 
		//-------   ------------------------------
		#640		   IO_SDC1_CMD_in		= 1'b0;	// 
		#640		   IO_SDC1_CMD_in		= 1'b0;	// 
		#640		   IO_SDC1_CMD_in		= 1'b0;	// 
		#640		   IO_SDC1_CMD_in		= 1'b0;	// 
		//-------   ------------------------------
		#640		   IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		   IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		   IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		   IO_SDC1_CMD_in		= 1'b0; 	// 
		//-------   ------------------------------
		#640		   IO_SDC1_CMD_in		= 1'b0;	// 
		#640		   IO_SDC1_CMD_in		= 1'b0;	// 
		#640		   IO_SDC1_CMD_in		= 1'b0;	// 
		#640		   IO_SDC1_CMD_in		= 1'b0;	// 
		//-------   ------------------------------
		#640		   IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		   IO_SDC1_CMD_in		= 1'b0; 	//       
		#640		   IO_SDC1_CMD_in		= 1'b0; 	//       22 14
		#640		   IO_SDC1_CMD_in		= 1'b0; 	//       21 13
		//-------------------------------------      20 12
		#640		   IO_SDC1_CMD_in		= 1'b0;	//       19 11
		#640		   IO_SDC1_CMD_in		= 1'b0;	// 	1  18 10
		#640		   IO_SDC1_CMD_in		= 1'b0;	// 	   17 9
		#640		   IO_SDC1_CMD_in		= 1'b1;	//       16 8  ready for data
		//-------   ------------------------------   
		#640		   IO_SDC1_CMD_in		= 1'b1; 	//       15 7
		#640		   IO_SDC1_CMD_in		= 1'b0; 	// 	   14 6
		#640		   IO_SDC1_CMD_in		= 1'b1; 	// 	a  13 5
		#640		   IO_SDC1_CMD_in		= 1'b0; 	//       12 4
		//-------   ------------------------------   
		#640		   IO_SDC1_CMD_in		= 1'b1;	//       11 3
		#640		   IO_SDC1_CMD_in		= 1'b0;	//       10 2
		#640		   IO_SDC1_CMD_in		= 1'b1;	// 	a  9  1
		#640		   IO_SDC1_CMD_in		= 1'b0;	//       8  0
		//-------   ------------------------------
		#640		   IO_SDC1_CMD_in		= 1'b0; 	//       7
		#640		   IO_SDC1_CMD_in		= 1'b0; 	// 	crc starts here
		#640		   IO_SDC1_CMD_in		= 1'b0; 	// 	1  5
		#640		   IO_SDC1_CMD_in		= 1'b1; 	//       4  
		//-------   ------------------------------
		#640		   IO_SDC1_CMD_in		= 1'b0;	// 	3  3
		#640		   IO_SDC1_CMD_in		= 1'b0;	//       2  
		#640		   IO_SDC1_CMD_in		= 1'b1;	//       1
		#640		   IO_SDC1_CMD_in		= 1'b1;	//       0
		// End of writing multiple blocks section.
		//      //////////////////////////////////////
		//      Now we read multiple blocks.
		// 0x0018   0x0000C0035 transfer mode, reading multiple blocks
		#20000		tf_mode		      = 36'h0000C0035;	
		// We need to set a starting read ddress.
		#6000 		sdc_rd_addr			= 32'h00030b2d;
		// Start the transfer process.
		// This will start the data_tf module.
		#200000	start_data_tf_strb	= 1'b1;					 
		#20		start_data_tf_strb	= 1'b0;		
		// Response from SD Card for CMD18. x12
		//-------------------------------------  
		#50000	IO_SDC1_CMD_in		= 1'b0; 	// start bit
		#640		IO_SDC1_CMD_in		= 1'b0; 	// transmission bit	
		#640		IO_SDC1_CMD_in		= 1'b0; 	// start of command index		
		#640		IO_SDC1_CMD_in		= 1'b1; 	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b1;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0; 	// start of card status response
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b1;	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		#640		IO_SDC1_CMD_in		= 1'b1; 	// 	
		#640		IO_SDC1_CMD_in		= 1'b1; 	// 
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 	
		#640		IO_SDC1_CMD_in		= 1'b1;	// ready_for_data
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0; 	// CRC next 7 bits
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	
		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	1
		#640		IO_SDC1_CMD_in		= 1'b1; 	// 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// 	3
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b1;	// 
		#640		IO_SDC1_CMD_in		= 1'b1;	// end bit
		//-------------------------------------	
	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b1; 	//       sc card release busy line
		//-------------------------------------
		// Busy signal from sd card while it saves the data.
		// The card pulls down the D0 low to indicate it is busy.
      // This is for the second block of data.
		//-------------------------------------  
//		#3200000	IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//   
//		//
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		// Response from SD Card for CMD13.
//      // This is when we poll the card to see
//      // if it is ready for the next block of data.
////		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		
//      #640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b1;	// fifth		D
//		#640		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh
//		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//      #640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       22 14
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       21 13
//		//-------------------------------------      20 12
//      #640		IO_SDC1_CMD_in		= 1'b0;	//       19 11
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	1  18 10
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	   17 9
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       16 8  ready for data
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       15 7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	   14 6
//		#640		IO_SDC1_CMD_in		= 1'b1; 	// 	a  13 5
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       12 4
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       11 3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       10 2
//		#640		IO_SDC1_CMD_in		= 1'b1;	// 	a  9  1
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       8  0
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	crc starts here
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	1  5
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       4  
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	3  3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       2  
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       1
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       0
//      //////////////////////////////////////
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b1; 	//       sc card release busy line
//		//-------------------------------------		
//		//-------------------------------------
//		// Busy signal from sd card while it saves the data.
//		// The card pulls down the D0 low to indicate it is busy.
//      // This is for the third block of data.
//		//-------------------------------------  
//		#2700000	IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//   
//		//
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		// Response from SD Card for CMD13.
//      // This is when we poll the card to see
//      // if it is ready for the next block of data.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b1;	// fifth		D
//		#640		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh
//		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       22 14
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       21 13
//		//-------------------------------------      20 12
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       19 11
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	1  18 10
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	   17 9
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       16 8  ready for data
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       15 7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	   14 6
//		#640		IO_SDC1_CMD_in		= 1'b1; 	// 	a  13 5
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       12 4
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       11 3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       10 2
//		#640		IO_SDC1_CMD_in		= 1'b1;	// 	a  9  1
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       8  0
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	crc starts here
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	1  5
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       4  
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	3  3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       2  
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       1
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       0
//      ////////////////////////////////////
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b1; 	//       sc card release busy line
//		//-------------------------------------			
////		//-------------------------------------		
////		//-------------------------------------	
//		//-------------------------------------
//		// Busy signal from sd card while it saves the data.
//		// The card pulls down the D0 low to indicate it is busy.
//      // This is for the fourth block of data.
//		//-------------------------------------  
//		#2700000	IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//   
//		//
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		// Response from SD Card for CMD13.
//      // This is when we poll the card to see
//      // if it is ready for the next block of data.
////		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b1;	// fifth		D
//		#640		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh
//		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       22 14
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       21 13
//		//-------------------------------------      20 12
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       19 11
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	1  18 10
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	   17 9
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       16 8  ready for data
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       15 7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	   14 6
//		#640		IO_SDC1_CMD_in		= 1'b1; 	// 	a  13 5
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       12 4
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       11 3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       10 2
//		#640		IO_SDC1_CMD_in		= 1'b1;	// 	a  9  1
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       8  0
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	crc starts here
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	1  5
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       4  
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	3  3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       2  
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       1
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       0
//      //////////////////////////////////////
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b1; 	//       sc card release busy line
//		//-------------------------------------			
////		//-------------------------------------	
//		//-------------------------------------
//		// Busy signal from sd card while it saves the data.
//		// The card pulls down the D0 low to indicate it is busy.
//      // This is for the fifth block of data.
////		//-------------------------------------  
//		#2700000	IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//   
//		//
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		// Response from SD Card for CMD13.
//      // This is when we poll the card to see
//      // if it is ready for the next block of data.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b1;	// fifth		D
//		#640		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh
//		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       22 14
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       21 13
//		//-------------------------------------      20 12
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       19 11
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	1  18 10
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	   17 9
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       16 8  ready for data
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       15 7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	   14 6
//		#640		IO_SDC1_CMD_in		= 1'b1; 	// 	a  13 5
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       12 4
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       11 3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       10 2
//		#640		IO_SDC1_CMD_in		= 1'b1;	// 	a  9  1
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       8  0
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	crc starts here
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	1  5
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       4  
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	3  3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       2  
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       1
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       0
////      //////////////////////////////////////
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b1; 	//       sc card release busy line
//		//-------------------------------------			
////		//-------------------------------------		
//		//-------------------------------------
//		// Busy signal from sd card while it saves the data.
//		// The card pulls down the D0 low to indicate it is busy.
//      // This is for the fifth block of data.
//		//-------------------------------------  
//		#2700000	IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//   
//		//
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		// Response from SD Card for CMD13.
//      // This is when we poll the card to see
//      // if it is ready for the next block of data.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b1;	// fifth		D
//		#640		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh
//		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       22 14
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       21 13
//		//-------------------------------------      20 12
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       19 11
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	1  18 10
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	   17 9
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       16 8  ready for data
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       15 7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	   14 6
//		#640		IO_SDC1_CMD_in		= 1'b1; 	// 	a  13 5
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       12 4
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       11 3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       10 2
//		#640		IO_SDC1_CMD_in		= 1'b1;	// 	a  9  1
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       8  0
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	crc starts here
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	1  5
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       4  
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	3  3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       2  
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       1
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       0
//      //////////////////////////////////////
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b1; 	//       sc card release busy line
//		//-------------------------------------			
////		//-------------------------------------	
//		//-------------------------------------
//		// Busy signal from sd card while it saves the data.
//		// The card pulls down the D0 low to indicate it is busy.
//      // This is for the sixth block of data.
//		//-------------------------------------  
//		#2700000	IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//   
//		//
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		// Response from SD Card for CMD13.
//      // This is when we poll the card to see
//      // if it is ready for the next block of data.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b1;	// fifth		D
//		#640		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh
//		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       22 14
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       21 13
//		//-------------------------------------      20 12
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       19 11
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	1  18 10
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	   17 9
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       16 8  ready for data
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       15 7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	   14 6
//		#640		IO_SDC1_CMD_in		= 1'b1; 	// 	a  13 5
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       12 4
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       11 3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       10 2
//		#640		IO_SDC1_CMD_in		= 1'b1;	// 	a  9  1
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       8  0
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	crc starts here
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	1  5
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       4  
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	3  3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       2  
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       1
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       0
//      //////////////////////////////////////
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b1; 	//       sc card release busy line
//		//-------------------------------------			
////		//-------------------------------------	
//		//-------------------------------------
//		// Busy signal from sd card while it saves the data.
//		// The card pulls down the D0 low to indicate it is busy.
//      // This is for the seventh block of data.
//		//-------------------------------------  
//		#2700000	IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//   
//		//
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		// Response from SD Card for CMD13.
//      // This is when we poll the card to see
//      // if it is ready for the next block of data.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b1;	// fifth		D
//		#640		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh
//		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       22 14
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       21 13
//		//-------------------------------------      20 12
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       19 11
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	1  18 10
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	   17 9
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       16 8  ready for data
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       15 7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	   14 6
//		#640		IO_SDC1_CMD_in		= 1'b1; 	// 	a  13 5
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       12 4
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       11 3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       10 2
//		#640		IO_SDC1_CMD_in		= 1'b1;	// 	a  9  1
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       8  0
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	crc starts here
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	1  5
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       4  
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	3  3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       2  
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       1
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       0
////      //////////////////////////////////////
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b1; 	//       sc card release busy line
//		//-------------------------------------			
////		//-------------------------------------	
//		//-------------------------------------
//		// Busy signal from sd card while it saves the data.
//		// The card pulls down the D0 low to indicate it is busy.
//      // This is for the eight block of data.
//		//-------------------------------------  
//		#2700000	IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//   
//		//
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		// Response from SD Card for CMD13.
//      // This is when we poll the card to see
//      // if it is ready for the next block of data.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b1;	// fifth		D
//		#640		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh
//		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       22 14
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       21 13
//		//-------------------------------------      20 12
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       19 11
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	1  18 10
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	   17 9
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       16 8  ready for data
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       15 7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	   14 6
//		#640		IO_SDC1_CMD_in		= 1'b1; 	// 	a  13 5
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       12 4
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       11 3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       10 2
//		#640		IO_SDC1_CMD_in		= 1'b1;	// 	a  9  1
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       8  0
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	crc starts here
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	1  5
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       4  
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	3  3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       2  
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       1
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       0
//      ////////////////////////////////////
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b1; 	//       sc card release busy line
//		//-------------------------------------			
////		//-------------------------------------		
//		//-------------------------------------
//		// Busy signal from sd card while it saves the data.
//		// The card pulls down the D0 low to indicate it is busy.
//      // This is for the ninth block of data.
//		//-------------------------------------  
//		#2700000	IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//   
//		//
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		// Response from SD Card for CMD13.
//      // This is when we poll the card to see
//      // if it is ready for the next block of data.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b1;	// fifth		D
//		#640		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh
//		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       22 14
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       21 13
//		//-------------------------------------      20 12
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       19 11
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	1  18 10
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	   17 9
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       16 8  ready for data
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       15 7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	   14 6
//		#640		IO_SDC1_CMD_in		= 1'b1; 	// 	a  13 5
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       12 4
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       11 3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       10 2
//		#640		IO_SDC1_CMD_in		= 1'b1;	// 	a  9  1
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       8  0
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	crc starts here
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	1  5
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       4  
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	3  3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       2  
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       1
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       0
//      //////////////////////////////////////
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b1; 	//       sc card release busy line
//		//-------------------------------------			
////		//-------------------------------------		
//		//-------------------------------------
//		// Busy signal from sd card while it saves the data.
//		// The card pulls down the D0 low to indicate it is busy.
//      // This is for the tenth block of data.
//		//-------------------------------------  
//		#2700000	IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//   
//		//
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		// Response from SD Card for CMD13.
//      // This is when we poll the card to see
//      // if it is ready for the next block of data.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b1;	// fifth		D
//		#640		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh
//		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       22 14
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       21 13
//		//-------------------------------------      20 12
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       19 11
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	1  18 10
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	   17 9
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       16 8  ready for data
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       15 7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	   14 6
//		#640		IO_SDC1_CMD_in		= 1'b1; 	// 	a  13 5
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       12 4
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       11 3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       10 2
//		#640		IO_SDC1_CMD_in		= 1'b1;	// 	a  9  1
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       8  0
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	crc starts here
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	1  5
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       4  
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	3  3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       2  
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       1
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       0
//      ////////////////////////////////////
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b1; 	//       sc card release busy line
//		//-------------------------------------			
////		//-------------------------------------	
//		//-------------------------------------
//		// Busy signal from sd card while it saves the data.
//		// The card pulls down the D0 low to indicate it is busy.
//      // This is for the eleventh block of data.
//		//-------------------------------------  
//		#2700000	IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//   
//		//
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		// Response from SD Card for CMD13.
//      // This is when we poll the card to see
//      // if it is ready for the next block of data.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b1;	// fifth		D
//		#640		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh
//		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       22 14
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       21 13
//		//-------------------------------------      20 12
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       19 11
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	1  18 10
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	   17 9
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       16 8  ready for data
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       15 7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	   14 6
//		#640		IO_SDC1_CMD_in		= 1'b1; 	// 	a  13 5
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       12 4
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       11 3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       10 2
//		#640		IO_SDC1_CMD_in		= 1'b1;	// 	a  9  1
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       8  0
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	crc starts here
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	1  5
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       4  
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	3  3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       2  
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       1
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       0
//      //////////////////////////////////////
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b1; 	//       sc card release busy line
//		//-------------------------------------			
////		//-------------------------------------		
//		//-------------------------------------
//		// Busy signal from sd card while it saves the data.
//		// The card pulls down the D0 low to indicate it is busy.
//      // This is for the twelveth block of data.
//		//-------------------------------------  
//		#2700000	IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//   
//		//
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		// Response from SD Card for CMD13.
//      // This is when we poll the card to see
//      // if it is ready for the next block of data.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b1;	// fifth		D
//		#640		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh
//		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       22 14
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       21 13
//		//-------------------------------------      20 12
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       19 11
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	1  18 10
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	   17 9
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       16 8  ready for data
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       15 7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	   14 6
//		#640		IO_SDC1_CMD_in		= 1'b1; 	// 	a  13 5
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       12 4
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       11 3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       10 2
//		#640		IO_SDC1_CMD_in		= 1'b1;	// 	a  9  1
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       8  0
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	crc starts here
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	1  5
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       4  
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	3  3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       2  
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       1
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       0
//      //////////////////////////////////////
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b1; 	//       sc card release busy line
//		//-------------------------------------			
////		//-------------------------------------	
//		//-------------------------------------
//		// Busy signal from sd card while it saves the data.
//		// The card pulls down the D0 low to indicate it is busy.
//      // This is for the thirteenth block of data.
//		//-------------------------------------  
//		#2700000	IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//   
//		//
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		// Response from SD Card for CMD13.
//      // This is when we poll the card to see
//      // if it is ready for the next block of data.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b1;	// fifth		D
//		#640		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh
//		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       22 14
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       21 13
//		//-------------------------------------      20 12
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       19 11
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	1  18 10
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	   17 9
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       16 8  ready for data
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       15 7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	   14 6
//		#640		IO_SDC1_CMD_in		= 1'b1; 	// 	a  13 5
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       12 4
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       11 3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       10 2
//		#640		IO_SDC1_CMD_in		= 1'b1;	// 	a  9  1
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       8  0
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	crc starts here
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	1  5
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       4  
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	3  3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       2  
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       1
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       0
//      ////////////////////////////////////
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b1; 	//       sc card release busy line
//		//-------------------------------------			
////		//-------------------------------------	
//		//-------------------------------------
//		// Busy signal from sd card while it saves the data.
//		// The card pulls down the D0 low to indicate it is busy.
//      // This is for the fourteenth block of data.
//		//-------------------------------------  
//		#2700000	IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//   
//		//
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		// Response from SD Card for CMD13.
//      // This is when we poll the card to see
//      // if it is ready for the next block of data.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b1;	// fifth		D
//		#640		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh
//		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       22 14
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       21 13
//		//-------------------------------------      20 12
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       19 11
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	1  18 10
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	   17 9
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       16 8  ready for data
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       15 7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	   14 6
//		#640		IO_SDC1_CMD_in		= 1'b1; 	// 	a  13 5
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       12 4
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       11 3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       10 2
//		#640		IO_SDC1_CMD_in		= 1'b1;	// 	a  9  1
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       8  0
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	crc starts here
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	1  5
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       4  
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	3  3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       2  
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       1
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       0
//      ////////////////////////////////////
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b1; 	//       sc card release busy line
//		//-------------------------------------			
////		//-------------------------------------	
//		//-------------------------------------
//		// Busy signal from sd card while it saves the data.
//		// The card pulls down the D0 low to indicate it is busy.
//      // This is for the fifteenth block of data.
//		//-------------------------------------  
//		#2700000	IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//   
//		//
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		// Response from SD Card for CMD13.
//      // This is when we poll the card to see
//      // if it is ready for the next block of data.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b1;	// fifth		D
//		#640		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh
//		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       22 14
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       21 13
//		//-------------------------------------      20 12
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       19 11
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	1  18 10
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	   17 9
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       16 8  ready for data
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       15 7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	   14 6
//		#640		IO_SDC1_CMD_in		= 1'b1; 	// 	a  13 5
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       12 4
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       11 3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       10 2
//		#640		IO_SDC1_CMD_in		= 1'b1;	// 	a  9  1
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       8  0
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	crc starts here
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	1  5
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       4  
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	3  3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       2  
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       1
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       0
//      //////////////////////////////////////
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b1; 	//       sc card release busy line
//		//-------------------------------------			
////		//-------------------------------------	
//		//-------------------------------------
//		// Busy signal from sd card while it saves the data.
//		// The card pulls down the D0 low to indicate it is busy.
//      // This is for the sixteenth block of data.
//		//-------------------------------------  
//		#2700000	IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//   
//		//
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		//-------------------------------------  
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		#640		IO_SDC1_D0_in		= 1'b0; 	//  	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 	
//		#640		IO_SDC1_D0_in		= 1'b0; 	// 
//		// Response from SD Card for CMD13.
//      // This is when we poll the card to see
//      // if it is ready for the next block of data.
//		//-------------------------------------  
//		#150000	IO_SDC1_CMD_in		= 1'b0; 	// first bit of response
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// second bit of response	
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// third		
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// fourth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b1;	// fifth		D
//		#640		IO_SDC1_CMD_in		= 1'b1;	// sixth
//		#640		IO_SDC1_CMD_in		= 1'b0;	// seventh
//		#640		IO_SDC1_CMD_in		= 1'b1;	// eigth
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       22 14
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       21 13
//		//-------------------------------------      20 12
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       19 11
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	1  18 10
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	   17 9
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       16 8  ready for data
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       15 7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	   14 6
//		#640		IO_SDC1_CMD_in		= 1'b1; 	// 	a  13 5
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       12 4
//		//-------------------------------------   
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       11 3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       10 2
//		#640		IO_SDC1_CMD_in		= 1'b1;	// 	a  9  1
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       8  0
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0; 	//       7
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	crc starts here
//		#640		IO_SDC1_CMD_in		= 1'b0; 	// 	1  5
//		#640		IO_SDC1_CMD_in		= 1'b1; 	//       4  
//		//-------------------------------------
//		#640		IO_SDC1_CMD_in		= 1'b0;	// 	3  3
//		#640		IO_SDC1_CMD_in		= 1'b0;	//       2  
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       1
//		#640		IO_SDC1_CMD_in		= 1'b1;	//       0
//      //////////////////////////////////////
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b0; 	//
//		#640		IO_SDC1_D0_in		= 1'b1; 	//       sc card release busy line
		//-------------------------------------			
//		//-------------------------------------								
	end
      
endmodule

