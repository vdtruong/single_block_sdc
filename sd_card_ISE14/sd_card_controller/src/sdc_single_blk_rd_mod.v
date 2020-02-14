`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////
// Company:       
// Engineer:      VDT
// 
// Create Date:    4:44 09/06/2019 
// Design Name: 
// Module Name:    sdc_single_blk_rd_mod.v 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 	This modules reads in one block of data from the sd
// 					card.  
// 					It has 5 states all together.
// 					1. State Idle.
// 					2. State Collect data.  This state collects the bits coming
// 					over from the SD card.  It will collect 64 bits of data for
// 					each register of the BRAM.
// 					3. State Latch Into BRAM.  When 64 bits of data have come
// 					over from the SD card, this state will latch the 64 bits
// 					word into the data BRAM.  It will also latch the CRC into
// 					a separate 64 bits register when the CRC has finished coming
// 					over for every block (512 bytes) of sd card data.  When the
// 					CRC is received, it will also signals to the ADMA2 state
// 					machine that the data transfer is complete.
// 					4. State Collect CRC.  This state will collect the CRC at
// 					the end of a block of data.  It will then go to state 5.
//						5. Latch crc into bram.	
//
// Dependencies: 	
//
// Revision:      09/06/2019 	Initial version.
//               
//               Revision 0.01 - File Created
// Additional Comments: 
//
///////////////////////////////////////////////////////////////////////////////
module sdc_single_blk_rd_mod(
   input					sdc_clk,			// sd card clock, much slower than fsys clock.		
   input 				reset,
	input		[15:0]	command,			// Only starts this state machine if the command is a read command.
	input					d0_in,			// sd card data line
	input 				adma_end,		// indicates if we are done with the transfer from ADMA2.		 	
	input		[15:0]	tf_mode,			// transfer mode
	//output reg			latch_wrd_strb,// ready to latch 64 bits word into bram.
	output				latch_wrd_strb,
	output				tfc,				// transfer of one block is complete
	//output reg			latch_crc_strb,// Finished capturing crc, latch into bram.
	output				latch_crc_strb,
	output	[63:0]	dat_wrd,			// 64 bits data word.  Each register of the PUC.
	output	[15:0] 	crc_16			// 16 bits crc register.
);	
												 														   
	reg				d0_in_z1; 			// delay
	reg				strt_bit_strb;		// falling edge has been detected from d0_in
   reg				strt_bit_strb_z1;	// We start shifting in the data one bit later.
	reg				ie_reg;				// input enable, we shift in the data when this is true.
	reg				ie_crc_reg;			// input enable for crc collection.
	reg				tfc_reg;				// finished reading one block of data.
	reg	[63:0]	dat_wrd_reg;		// 64 bits data word.  Each register of the PUC.
	reg	[15:0] 	crc_16_reg;			// 16 bits crc register.
	reg				crc_rdy_strb_z1;	// delay
	reg				not_strted;			// flag that we have not started taking data
	reg				wrd_rdy_strb_z1;	// delay
	reg				wrd_rdy_strb_z2;	// delay
	reg				fin_blk_strb_z1;	// delay

	wire 				fin_blk_strb;		// Finished with 1 block of data (64 words, 512 bytes).
	wire	[7:0] 	wrd_cnt;				// Counts how many words have been collected from sd card.
	wire	[4:0]		crc_shift_cnt;		// bit count for crc shift
	wire				wrd_rdy_strb;		// 64 bits for each word are collected
	wire	[5:0]		bit_shift_cnt;		// bit shift cnts for each word
	wire				crc_rdy_strb;		// crc word is ready

	// Initialize sequential logic
   initial			
	begin								
   	d0_in_z1		   	<= 1'b0; 	
		strt_bit_strb		<= 1'b0;
		strt_bit_strb_z1	<= 1'b0;
		ie_reg				<= 1'b0;
		ie_crc_reg			<= 1'b0;
		tfc_reg				<= 1'b0;
		not_strted			<= 1'b1;
		wrd_rdy_strb_z1	<= 1'b0;
		wrd_rdy_strb_z2	<= 1'b0;
		//latch_wrd_strb		<= 1'b0;
		//latch_crc_strb		<= 1'b0;
		fin_blk_strb_z1	<= 1'b0;
	end
	
	// Set up delays.
	always @(posedge sdc_clk)
	begin
		if (reset) begin
			d0_in_z1				<= 1'b0; 
			strt_bit_strb_z1	<= 1'b0;
			crc_rdy_strb_z1	<= 1'b0;
			wrd_rdy_strb_z1	<= 1'b0;
			wrd_rdy_strb_z2	<= 1'b0;
			fin_blk_strb_z1	<= 1'b0;
		end
		else begin
			d0_in_z1				<= d0_in; 
			strt_bit_strb_z1	<= strt_bit_strb;
			crc_rdy_strb_z1	<= crc_rdy_strb;
			wrd_rdy_strb_z1	<= wrd_rdy_strb;
			wrd_rdy_strb_z2	<= wrd_rdy_strb_z1;
			fin_blk_strb_z1	<= fin_blk_strb;
		end
	end   
	
	// for the adma2 module												  
	assign tfc	= tfc_reg;
	// for data bram
	assign dat_wrd = dat_wrd_reg;
   assign crc_16 = crc_16_reg;
	assign latch_wrd_strb = wrd_rdy_strb && !not_strted;
	assign latch_crc_strb = crc_rdy_strb;

	// Create the not_strted flag when data has not come in yet.
	// If we have a start bit from the sd card, we have started
	// to collect the data.
	always @(posedge sdc_clk) begin
		if (reset)
			not_strted	<= 1'b1;
		else if (crc_rdy_strb)		// when crc is done, bring up not_strted flag
      	not_strted	<= 1'b1;              
 		else if (strt_bit_strb)		// bring down not_strted flag when we have a start bit                         
         not_strted	<= 1'b0;
	end

	// Create the start bit strobe but only the first time it happens.
	always @(posedge sdc_clk) begin
		if (reset)
			strt_bit_strb 	<= 1'b0;
		// start bit has been detected from falling edge
		// and only if tf_mode is reading.
 		if ((!d0_in && d0_in_z1 && not_strted) && tf_mode[4])		
			strt_bit_strb	<= 1'b1;             
		else                          
         strt_bit_strb	<= 1'b0;
	end

	// Strobe the bram fifo when wrd_rdy_strb && !not_strted and read commands
	// only.
	//always @(posedge sdc_clk) begin
	//	if (reset)
	//		latch_wrd_strb <= 1'b0;
	//	if ((wrd_rdy_strb && !not_strted) && (command[13:8] == 6'h11 || command[13:8] == 6'h12)) 		
     // 	latch_wrd_strb	<= 1'b1;             
	//	else                          
     //    latch_wrd_strb	<= 1'b0;
	//end

	// Strobe the bram fifo when crc_rdy_strb and read commands only.
	//always @(posedge sdc_clk) begin
	//	if (reset)
	//		latch_crc_strb <= 1'b0;
	//	if (crc_rdy_strb && (command[13:8] == 6'h11 || command[13:8] == 6'h12)) 		
     // 	latch_crc_strb	<= 1'b1;             
	//	else                          
     //    latch_crc_strb	<= 1'b0;
	//end

	/////////////////////////////////////////////////////////////////////////
	//-------------------------------------------------------------------------
	// Need a 64 clocks counter to keep track of each (64 bits) word.
	//-------------------------------------------------------------------------
	defparam bit_shift_cntr.dw 	= 6;
	defparam bit_shift_cntr.max	= 6'h3E; //6'h3F;	
	//-------------------------------------------------------------------------
	CounterSeq bit_shift_cntr(
		.clk(sdc_clk), 	 
		.reset(reset),	
		.enable(1'b1), 	
		.start_strb(strt_bit_strb | (~not_strted && wrd_rdy_strb && (wrd_cnt < 6'h3f))), 	 	
		.cntr(bit_shift_cnt), 
		.strb(wrd_rdy_strb)            
	);	 
 
	// Set ie_reg true during the 64 clocks counter.
   always @(posedge sdc_clk) begin
      if (reset)
         ie_reg <= 1'b0;
      else if (!d0_in && d0_in_z1 && not_strted /*strt_bit_strb*/)
         ie_reg <= 1'b1;
 		else if (fin_blk_strb)
			ie_reg <= 1'b0;
   end	
      
	// Shift (left) the data for each 64 bits word.
	always @(posedge sdc_clk)
	begin
		if (reset)
			dat_wrd_reg 			<= {64{1'b0}};
 		// Shifts in from LSB.
 		else if (ie_reg) begin
			dat_wrd_reg[0] 		<= d0_in;
 			dat_wrd_reg[63:1] 	<= dat_wrd_reg[62:0];
		end
		// Clear after every block.
		else if (fin_blk_strb)
			dat_wrd_reg 			<= {64{1'b0}};
	end
 
	//-------------------------------------------------------------------------
	// We need a counter to count how many words (regs.) have been read.
	// If we have read 64 words (1 block), we need to read the crc.
	//-------------------------------------------------------------------------
	defparam wrd_cntr.dw 	= 8;
	// Count up to this number, starting at zero.
	defparam wrd_cntr.max	= 8'h40; //8'h3F; //8'h40;	
	//-------------------------------------------------------------------------
	Counter wrd_cntr(
		.clk(sdc_clk), 		 
		.reset(reset),	 
		.enable(wrd_rdy_strb),   	 	
		.cntr(wrd_cnt), 
		.strb(fin_blk_strb) 
	);	
  
	/////////////////////////////////////////////////////////////////////////
	//-------------------------------------------------------------------------
	// Need a 13 clocks counter to shift in the crc.
	// This is because we start early by 3 clocks.
	//-------------------------------------------------------------------------
	defparam crc_shift_cntr.dw 	= 5;
	defparam crc_shift_cntr.max	= 5'hD;	
	//-------------------------------------------------------------------------
	CounterSeq crc_shift_cntr(
		.clk(sdc_clk), 	 
		.reset(reset),	
		.enable(1'b1), 	
		.start_strb(/*fin_blk_strb*/wrd_rdy_strb_z1 && wrd_cnt == 8'h40), 	 	
		.cntr(crc_shift_cnt), 
		.strb(crc_rdy_strb)            
	);	 
 
	// Set ie_crc_reg true to shift in the crc.
   always @(posedge sdc_clk) begin
      if (reset)
         ie_crc_reg <= 1'b0;	// rising edge
      //else if ((wrd_rdy_strb && !wrd_rdy_strb_z1) && (wrd_cnt == 8'h3F) /*fin_blk_strb && !fin_blk_strb_z1*/)	// rising edge
      else if (bit_shift_cnt == 6'h3E && wrd_cnt == 8'h3F)  
			ie_crc_reg <= 1'b1;
 		else if (crc_rdy_strb)
			ie_crc_reg <= 1'b0;
   end	
      
	// Shift in crc (left).
	always @(posedge sdc_clk)
	begin
		if (reset)
			crc_16_reg			<= {16{1'b0}};
 		else if (ie_crc_reg) begin
			crc_16_reg[0] 		<= d0_in;
 			crc_16_reg[15:1] 	<= crc_16_reg[14:0];
		end
		else if (tfc_reg) // clear for next crc
			crc_16_reg			<= {16{1'b0}};
	end

	// Single block read State Machine
	// There are five states:
	// 1. Idle
	// 2. rd_data
	// 3. latch_to_bram
	// 4. rd_crc
	// 5. latch crc to bram
	parameter state_idle 	      = 5'b0_0001; 	// idle											x01
   parameter state_rd_dat 			= 5'b0_0010;	// rd_data										x02
   parameter state_latch_bram 	= 5'b0_0100;	// latch single word (64 bits) to bram	x04
   parameter state_rd_crc 			= 5'b0_1000;	// rd_crc										x08
   parameter state_latch_crc		= 5'b1_0000;	// latch crc to bram							x10

	(* FSM_ENCODING="ONE-HOT", SAFE_IMPLEMENTATION="YES", 
	SAFE_RECOVERY_STATE="state_stop" *) 
	reg [4:0] state = state_idle;

   always@(posedge sdc_clk)
      if (reset) begin
         state 								   <= state_idle;    
         //<outputs> <= <initial_values>;				
			tfc_reg					   			<= 1'b0;	       	
      end
      else
         (* PARALLEL_CASE *) case (state)
            state_idle : begin				// x0001
               // start bit has been detected from falling edge of d0_in
					// Also, the "end" desciptor parameter is not set.
					if (strt_bit_strb && (command[13:8] == 6'h11 || command[13:8] == 6'h12) /*&& !adma_end*/)	
						state 					   <= state_rd_dat;             
               else                          
                  state 					   <= state_idle;   
               //<outputs> <= <values>;   		  	     
					tfc_reg			   			<= 1'b0;	     
            end                              
            state_rd_dat : begin        	// x0002     
					if (wrd_rdy_strb) 			// Finished with 64 bits word.
						state 						<= state_latch_bram;
			 		else if (fin_blk_strb)
						state							<= state_rd_crc;
			 		else
						state							<= state_rd_dat;
               //<outputs> <= <values>;   		  									   
					tfc_reg			   			<= 1'b0;	     
            end  													
            state_latch_bram : begin		// x0004
               if (wrd_rdy_strb_z1 && ie_crc_reg)     		// If finished with data block, start to collect the crc.   
               	state 		        	 	<= state_rd_crc;         
               //else if (!fin_blk_strb)                       
                 // state 				   	<= state_rd_dat;
			 		else                   
             		state							<= state_rd_dat; 
               //<outputs> <= <values>;	 			
					tfc_reg			   			<= 1'b0;	                      	
            end
            state_rd_crc : begin    		// x0008
               if (crc_rdy_strb)   			// if done collecting crc   
                  state 		            <= state_latch_crc;	// latch crc into the bram 
               else                    
                  state 				      <= state_rd_crc;  
               //<outputs> <= <values>;		 		
						tfc_reg			   		<= 1'b0;  	  
            end                           								  
            state_latch_crc : begin       // x0010     
					state								<= state_idle;
               //<outputs> <= <values>;   		  									   
					// indicates transfer complete as soon as we get into this
					// state.  The ADMA2 state machine will advance and get back
					// into this module if we are not done with all the descriptor
					// tables.
					tfc_reg			   			<= 1'b1;	     
            end 
				default: begin  					// Fault Recovery
               state 						   <= state_idle;   
               //<outputs> <= <values>;   				   
					tfc_reg			   			<= 1'b0;
				end
         endcase			

endmodule
