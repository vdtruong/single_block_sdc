`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 	PolySoftique Inc.
// Engineer: 	VDT
// //
// Create Date:   10/18/2019
// Design Name:   sdc_controller_mod
// Module Name:   C:/FPGA_Design_Test/sd_card_ISE14/sd_card_controller/tf/sdc_controller_mod_multi_blks_rd_tb.v
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
// Simulating multiple blocks read from sdc.
////////////////////////////////////////////////////////////////////////////////

module sdc_controller_mod_multi_blks_rd_tb;

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
   
   integer 		incr;
   parameter 	WIDTH=64;
   reg 			[WIDTH-1:0] DATA;
   integer 		i, j, k;

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
		//-------------------------------------	
		//-------------------------------------		
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
      // Clock is now about 1 MHz after successful intialization.
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
		////////////////////////////////////////
		
		////////////////////////////////////////
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
		#640		IO_SDC1_CMD_in		= 1'b1; 	//	1 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b1;	// 2	cmd18 in hex x12
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
		// Wait a while before starting to send back data.
		#1_000_000;	// 1 ms
		
		// Data returning from sdc at 1.56 MHz rate.
		for (j=0; j<16; j=j+1) begin	// need to do 16 blocks
			// This is for 1 block of data, 512 bytes.
			// Each word of data is 2 clocks late.
			// Therefore, we add 2*64 bits to the count.
			for (i=0; i<4115; i=i+1) begin
				// Start bit.
				if (i == 0) begin
					#640 IO_SDC1_D0_in = 1'b0; 
 				end
				// Start of data block.
				else if (i>0 && i<4098) begin 
					if (i & 1) begin	// If number is odd.
						#640 IO_SDC1_D0_in = 1'b1;
	 				end
					else begin
						#640 IO_SDC1_D0_in = 1'b0;
	 				end
		 		end						
				// end of 1 block of data
				// start of crc
				else if (i> 4097 && i<4114) begin	
					// 16 bits CRC after every block.
					// Need to do this with each bit.
					if (i & 1) begin	// If number is odd.
						#640 IO_SDC1_D0_in = 1'b0;
	 				end
					else begin
						#640 IO_SDC1_D0_in = 1'b1;
	 				end
				end
				// end of crc
				// stop bit
				else if (i == 4114) begin
					#640 IO_SDC1_D0_in = 1'b1;	
		 		end
			end
			// End of one block of data.
			#1_000_000; // wait before starting another block, 1 ms
 		end
		// Done with 16 blocks of data.
		
		// After receiving, release D0_in.
		//IO_SDC1_D0_in = 1'b1;

		// After 1 us, send the cmd12 response.
		// Response from SD Card for CMD12. x0c
		//-------------------------------------  
		#1000		IO_SDC1_CMD_in		= 1'b0; 	// start bit
		#640		IO_SDC1_CMD_in		= 1'b0; 	// transmission bit	
		#640		IO_SDC1_CMD_in		= 1'b0; 	// start of command index		
		#640		IO_SDC1_CMD_in		= 1'b0; 	//	0
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b1;	// 
		#640		IO_SDC1_CMD_in		= 1'b1;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// c	cmd12 in hex x0c
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
		////////////////////////////////////////
		
		////////////////////////////////////////
		//      The second multiple blocks read.
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
		#640		IO_SDC1_CMD_in		= 1'b1; 	//	1 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b1;	// 2	cmd18 in hex x12
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
		// Wait a while before starting to send back data.
		#1_000_000;	// 1 ms
		
		// Data returning from sdc at 1.56 MHz rate.
		for (j=0; j<16; j=j+1) begin	// need to do 16 blocks
			// This is for 1 block of data, 512 bytes.
			// Each word of data is 2 clocks late.
			// Therefore, we add 2*64 bits to the count.
			for (i=0; i<4115; i=i+1) begin
				// Start bit.
				if (i == 0) begin
					#640 IO_SDC1_D0_in = 1'b0; 
 				end
				// Start of data block.
				else if (i>0 && i<4098) begin 
					if (i & 1) begin	// If number is odd.
						#640 IO_SDC1_D0_in = 1'b1;
	 				end
					else begin
						#640 IO_SDC1_D0_in = 1'b0;
	 				end
		 		end						
				// end of 1 block of data
				// start of crc
				else if (i> 4097 && i<4114) begin	
					// 16 bits CRC after every block.
					// Need to do this with each bit.
					if (i & 1) begin	// If number is odd.
						#640 IO_SDC1_D0_in = 1'b0;
	 				end
					else begin
						#640 IO_SDC1_D0_in = 1'b1;
	 				end
				end
				// end of crc
				// stop bit
				else if (i == 4114) begin
					#640 IO_SDC1_D0_in = 1'b1;	
		 		end
			end
			// End of one block of data.
			#1_000_000; // wait before starting another block, 1 ms
 		end
		// Done with 16 blocks of data.
		
		// After receiving, release D0_in.
		//IO_SDC1_D0_in = 1'b1;

		// After 1 us, send the cmd12 response.
		// Response from SD Card for CMD12. x0c
		//-------------------------------------  
		#1000		IO_SDC1_CMD_in		= 1'b0; 	// start bit
		#640		IO_SDC1_CMD_in		= 1'b0; 	// transmission bit	
		#640		IO_SDC1_CMD_in		= 1'b0; 	// start of command index		
		#640		IO_SDC1_CMD_in		= 1'b0; 	//	0
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b1;	// 
		#640		IO_SDC1_CMD_in		= 1'b1;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// c	cmd12 in hex x0c
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
      
		////////////////////////////////////////
		//      The third multiple blocks read.
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
		#640		IO_SDC1_CMD_in		= 1'b1; 	//	1 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b1;	// 2	cmd18 in hex x12
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
		// Wait a while before starting to send back data.
		#1_000_000;	// 1 ms
		
		// Data returning from sdc at 1.56 MHz rate.
		for (j=0; j<16; j=j+1) begin	// need to do 16 blocks
			// This is for 1 block of data, 512 bytes.
			// Each word of data is 2 clocks late.
			// Therefore, we add 2*64 bits to the count.
			for (i=0; i<4115; i=i+1) begin
				// Start bit.
				if (i == 0) begin
					#640 IO_SDC1_D0_in = 1'b0; 
 				end
				// Start of data block.
				else if (i>0 && i<4098) begin 
					if (i & 1) begin	// If number is odd.
						#640 IO_SDC1_D0_in = 1'b1;
	 				end
					else begin
						#640 IO_SDC1_D0_in = 1'b0;
	 				end
		 		end						
				// end of 1 block of data
				// start of crc
				else if (i> 4097 && i<4114) begin	
					// 16 bits CRC after every block.
					// Need to do this with each bit.
					if (i & 1) begin	// If number is odd.
						#640 IO_SDC1_D0_in = 1'b0;
	 				end
					else begin
						#640 IO_SDC1_D0_in = 1'b1;
	 				end
				end
				// end of crc
				// stop bit
				else if (i == 4114) begin
					#640 IO_SDC1_D0_in = 1'b1;	
		 		end
			end
			// End of one block of data.
			#1_000_000; // wait before starting another block, 1 ms
 		end
		// Done with 16 blocks of data.
		
		// After receiving, release D0_in.
		//IO_SDC1_D0_in = 1'b1;

		// After 1 us, send the cmd12 response.
		// Response from SD Card for CMD12. x0c
		//-------------------------------------  
		#1000		IO_SDC1_CMD_in		= 1'b0; 	// start bit
		#640		IO_SDC1_CMD_in		= 1'b0; 	// transmission bit	
		#640		IO_SDC1_CMD_in		= 1'b0; 	// start of command index		
		#640		IO_SDC1_CMD_in		= 1'b0; 	//	0
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b1;	// 
		#640		IO_SDC1_CMD_in		= 1'b1;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// c	cmd12 in hex x0c
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
		
		////////////////////////////////////////
		//      The fourth multiple blocks read.
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
		#640		IO_SDC1_CMD_in		= 1'b1; 	//	1 
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// 
		#640		IO_SDC1_CMD_in		= 1'b1;	// 2	cmd18 in hex x12
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
		// Wait a while before starting to send back data.
		#1_000_000;	// 1 ms
		
		// Data returning from sdc at 1.56 MHz rate.
		for (j=0; j<16; j=j+1) begin	// need to do 16 blocks
			// This is for 1 block of data, 512 bytes.
			// Each word of data is 2 clocks late.
			// Therefore, we add 2*64 bits to the count.
			for (i=0; i<4115; i=i+1) begin
				// Start bit.
				if (i == 0) begin
					#640 IO_SDC1_D0_in = 1'b0; 
 				end
				// Start of data block.
				else if (i>0 && i<4098) begin 
					if (i & 1) begin	// If number is odd.
						#640 IO_SDC1_D0_in = 1'b1;
	 				end
					else begin
						#640 IO_SDC1_D0_in = 1'b0;
	 				end
		 		end						
				// end of 1 block of data
				// start of crc
				else if (i> 4097 && i<4114) begin	
					// 16 bits CRC after every block.
					// Need to do this with each bit.
					if (i & 1) begin	// If number is odd.
						#640 IO_SDC1_D0_in = 1'b0;
	 				end
					else begin
						#640 IO_SDC1_D0_in = 1'b1;
	 				end
				end
				// end of crc
				// stop bit
				else if (i == 4114) begin
					#640 IO_SDC1_D0_in = 1'b1;	
		 		end
			end
			// End of one block of data.
			#1_000_000; // wait before starting another block, 1 ms
 		end
		// Done with 16 blocks of data.
		
		// After receiving, release D0_in.
		//IO_SDC1_D0_in = 1'b1;

		// After 1 us, send the cmd12 response.
		// Response from SD Card for CMD12. x0c
		//-------------------------------------  
		#1000		IO_SDC1_CMD_in		= 1'b0; 	// start bit
		#640		IO_SDC1_CMD_in		= 1'b0; 	// transmission bit	
		#640		IO_SDC1_CMD_in		= 1'b0; 	// start of command index		
		#640		IO_SDC1_CMD_in		= 1'b0; 	//	0
		//-------------------------------------
		#640		IO_SDC1_CMD_in		= 1'b1;	// 
		#640		IO_SDC1_CMD_in		= 1'b1;	// 
		#640		IO_SDC1_CMD_in		= 1'b0;	// c	cmd12 in hex x0c
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

	end	// end of intial loop

endmodule

