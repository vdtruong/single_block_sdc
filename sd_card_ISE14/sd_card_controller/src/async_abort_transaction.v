`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:         VDT 
// 
// Create Date:    19:22:59 08/24/2016 
// Design Name: 
// Module Name:    async_abort_transaction 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 3.8.1
//                      An abort transaction is performed by issuing CMD12 for 
//                      a SD memory card and by issuing CMD52 for a
//                      SDIO card. There are two cases where the Host 
//                      Driver needs to do an Abort Transaction. The first case is
//                      when the Host Driver stops Infinite Block Transfers. 
//                      The second case is when the Host Driver stops
//                      transfers while a Multiple Block Transfer is executing.
//                      There are two ways to issue an Abort Command. The first 
//                      is an asynchronous abort. The second is a
//                      synchronous abort. In an asynchronous abort sequence, 
//                      the Host Driver can issue an Abort Command at
//                      anytime unless Command Inhibit (CMD) in the Present State 
//                      register is set to 1. In a synchronous abort,
//                      the Host Driver shall issue an Abort Command after the 
//                      data transfer stopped by using Stop At Block
//                      Gap Request in the Block Gap Control register.
//                      3.8.1 Asynchronous Abort
//                      The sequence for Asynchronous Abort is shown in 
//                      Figure 3-16.
//                      (1) Issue Abort Command in accordance with Section 3.7.1
//                      (2) Set both Software Reset For DAT Line and Software 
//                      Reset For CMD Line to 1 in the Software
//                      Reset register to do software reset.
//                      (3) Check Software Reset For DAT Line and Software Reset 
//                      For CMD Line in the Software Reset
//                      register. If both Software Reset For DAT Line and 
//                      Software Reset For CMD Line are 0, go to
//                      "End". If either Software Reset For DAT Line or 
//                      Software Reset For CMD Line is 1, go to step (3).
//////////////////////////////////////////////////////////////////////////////////
module async_abort_transaction(
   input             clock,
   input             reset,
   input             enb_abort_trans,  // from host controller
   input	            fin_cmnd_strb,    // finished with command
   output            iss_abrt_cmd,     // starts the iss_sd_cmd module for cmd 12
	// For use with sd_host_controller. 
	output	[11:0]	rd_reg_index, 
	input 	[127:0]	rd_reg_input, 
	output				wr_reg_strb, 
	output	[11:0]	wr_reg_index, 
	output 	[31:0]	wr_reg_output,
   output            async_abort_trans_proc
   );
   
   reg         rd_input_strb;
   reg         iss_abrt_cmd_reg;       // send out auto cmd12 for multiple blocks transfer
	reg 			wr_reg_strb_reg;
	reg [11:0] 	wr_reg_index_reg;
	reg [31:0]	wr_reg_output_reg;
	reg [11:0] 	rd_reg_index_reg; 
   reg         async_abort_trans_proc_reg;
   
	wire		   read_clks_tout;         // finished reading register from host controller
	// Get out of waiting if has not received a response from a cmnd.
	//wire		   rd_to_strb;	    
   
   
	// Initialize sequential logic
	initial			
	begin
		iss_abrt_cmd_reg		      <= 1'b0;
		wr_reg_strb_reg	         <= 1'b0;		
		wr_reg_index_reg		      <= 12'h000;	
		wr_reg_output_reg		      <= 32'h00000000;
		rd_input_strb		         <= 1'b0;	
		rd_reg_index_reg		      <= 12'h000;	
      async_abort_trans_proc_reg <= 1'b0; 
	end
   
	// Assign wires or registers (need to check) to outputs.
	assign iss_abrt_cmd           = iss_abrt_cmd_reg;  	  
	assign wr_reg_strb   			= wr_reg_strb_reg;	
	assign wr_reg_index				= wr_reg_index_reg;	
	assign wr_reg_output				= wr_reg_output_reg;	 
	assign rd_reg_index		      = rd_reg_index_reg;	
   assign async_abort_trans_proc = async_abort_trans_proc_reg;

	//-------------------------------------------------------------------------
	// We need a x clocks counter.  It takes 1 clock to get a reading for the
	// memory map from the host controller.  However, we'll use x clocks
	// to give it some room.  We also use this counter if we have two writes
	// in the row.  This also gives it some room.
	//-------------------------------------------------------------------------
	defparam readClksCntr_u1.dw 	= 3;
	// Change this to reflect the number of counts you want.
	// Count up to this number, starting at zero.
	defparam readClksCntr_u1.max	= 3'h6;	
	//-------------------------------------------------------------------------
	CounterSeq readClksCntr_u1(
		.clk(clock), 		// Clock input 50 MHz 
		.reset(reset),		// GS
		.enable(1'b1), 	
		// start the timing
		.start_strb(rd_input_strb || wr_reg_strb_reg),
		.cntr(), 
		.strb(read_clks_tout) 
	);	  

	//-------------------------------------------------------------------------
	// If we waited for 1 second and a command hasn't been responded yet,
	// get out of the state machine.
	// Read Time Out Clocks Counter.
	//-------------------------------------------------------------------------
	//defparam readToClksCntr.dw 	= 28;
	// Change this to reflect the number of counts you want.
	// Count up to this number, starting at zero.
	//defparam readToClksCntr.max	= 28'h2FAF080;	
	//-------------------------------------------------------------------------
	/*CounterSeq readToClksCntr(
		.clk(clock), 		// Clock input 50 MHz 
		.reset(reset),		// GSR
		.enable(1'b1), 	
		// start the timing
		.start_strb(rd_input_strb),   	 	
		.cntr(), 
		.strb(rd_to_strb) 
	);*/		
   
   parameter st_strt                	= 10'b00_0000_0001;	// 001
   parameter st_iss_abrt_cmd        	= 10'b00_0000_0010;	// 002
   parameter st_iss_abrt_cmd_wt     	= 10'b00_0000_0100;	// 004
   parameter st_set_sftwre_rst      	= 10'b00_0000_1000;	// 008
   parameter st_set_sftwre_rst_wt   	= 10'b00_0001_0000;	// 010
   parameter st_chk_dr_and_cr       	= 10'b00_0010_0000;	// 020
   parameter st_chk_dr_and_cr_wt    	= 10'b00_0100_0000;	// 040
   parameter st_clr_sftw_rst_bits   	= 10'b00_1000_0000;	// 080
	parameter st_clr_sftw_rst_bits_wt	= 10'b01_0000_0000;	// 100
	parameter st_end                 	= 10'b10_0000_0000;	// 200

   (* FSM_ENCODING="ONE-HOT", SAFE_IMPLEMENTATION="YES", 
   SAFE_RECOVERY_STATE="<recovery_state_value>" *) 
   reg [9:0] state = st_strt;

   always@(posedge clock)
      if (reset) begin
         state                            <= st_strt;
         //<outputs> <= <values>;         
         iss_abrt_cmd_reg                 <= 1'b0;
			rd_input_strb	            		<= 1'b0;			
			rd_reg_index_reg 				      <= 12'h000;	
			wr_reg_strb_reg				      <= 1'b0;	
			wr_reg_index_reg				      <= 12'h000;	
			wr_reg_output_reg				      <= {32{1'b0}};	
         async_abort_trans_proc_reg       <= 1'b0;	
      end
      else
         (* PARALLEL_CASE *) case (state)
            st_strt : begin
               if (enb_abort_trans)
                  state                   <= st_iss_abrt_cmd;
               else                       
                  state                   <= st_strt;
                  //<outputs> <= <values>;
               iss_abrt_cmd_reg           <= 1'b0;
               rd_input_strb	            <= 1'b0;			    
               rd_reg_index_reg    			<= 12'h000;		
               wr_reg_strb_reg	   	   <= 1'b0;			
               wr_reg_index_reg	   		<= 12'h000;		
               wr_reg_output_reg   		   <= {32{1'b0}};
               async_abort_trans_proc_reg <= 1'b0;			
            end
            st_iss_abrt_cmd : begin
               state                      <= st_iss_abrt_cmd_wt;
                  //<outputs> <= <values>;
               iss_abrt_cmd_reg           <= 1'b1;    					// start strobe - start 3.7.1.1
               rd_input_strb	            <= 1'b0;			
               rd_reg_index_reg    	      <= 12'h000;		
               wr_reg_strb_reg	         <= 1'b0;			
               wr_reg_index_reg	         <= 12'h000;		
               wr_reg_output_reg   	      <= {32{1'b0}};
               async_abort_trans_proc_reg <= 1'b0;		             
            end
            st_iss_abrt_cmd_wt : begin											// wait until 3.7.1.2 to finish
               if (fin_cmnd_strb)               							// may need time out
                  state                   <= st_set_sftwre_rst; 
               else                       
                  state                   <= st_iss_abrt_cmd_wt;
                  //<outputs> <= <values>;
               iss_abrt_cmd_reg           <= 1'b0;    					// end strobe
               rd_input_strb	            <= 1'b0;			
               rd_reg_index_reg    	      <= 12'h000;		
               wr_reg_strb_reg	         <= 1'b0;			
               wr_reg_index_reg	         <= 12'h000;		
               wr_reg_output_reg   	      <= {32{1'b0}};
               async_abort_trans_proc_reg <= 1'b0;		 
            end
				// When the above are done, start the software reset in the host controller memory map.
            st_set_sftwre_rst : begin											// 008						
					state                      <= st_set_sftwre_rst_wt;
               //<outputs> <= <values>;   
               iss_abrt_cmd_reg           <= 1'b0;        
               rd_input_strb	            <= 1'b0;			 
               rd_reg_index_reg 	         <= 12'h000;		 
               wr_reg_strb_reg	         <= 1'b1;							// Set strobe.		 
               wr_reg_index_reg	         <= 12'h02F;		 
               wr_reg_output_reg	         <= 32'h00000006;				// Reset the necessary bits.
               async_abort_trans_proc_reg <= 1'b1;    					// need to talk to host controller		 
            end
				// Wait here for six clocks then check the softwre reset register to
				// see if the reset is done.
            st_set_sftwre_rst_wt : begin										// 010		 				 
               if (read_clks_tout)
                  state 				      <= st_chk_dr_and_cr;
               else if (!read_clks_tout)										
						state 	               <= st_set_sftwre_rst_wt;	// Now go see if the reset is done.
               else                 
                  state 				      <= st_strt;	
                  //<outputs> <= <values>;
               iss_abrt_cmd_reg           <= 1'b0;     
               rd_input_strb	            <= 1'b0;		
               rd_reg_index_reg    	      <= 12'h000;	
               wr_reg_strb_reg	         <= 1'b0;		
               wr_reg_index_reg	         <= 12'h02F;	
               wr_reg_output_reg   	      <= 32'h00000006;
               async_abort_trans_proc_reg <= 1'b1;							// need to talk to host controller 
            end	
            st_chk_dr_and_cr : begin											// 020
               state                      <= st_chk_dr_and_cr_wt;
               //<outputs> <= <values>;
               iss_abrt_cmd_reg           <= 1'b0;        
               rd_input_strb	            <= 1'b1;			 
               rd_reg_index_reg 	         <= 12'h02F;		 
               wr_reg_strb_reg	         <= 1'b0;			 
               wr_reg_index_reg	         <= 12'h000;		 
               wr_reg_output_reg	         <= 32'h00000000;
               async_abort_trans_proc_reg <= 1'b1;		 					// need to talk to host controller
            end
				// Give it six clocks to reset the bits.
				// After six clocks, assume bits are reset.
            st_chk_dr_and_cr_wt : begin										// 040
               if (read_clks_tout)
                  state 				      <= st_clr_sftw_rst_bits;
               else if (!read_clks_tout)
                  state 				      <= st_chk_dr_and_cr_wt;		 
					//
               else
                  state 			         <= st_strt;	
               iss_abrt_cmd_reg           <= 1'b0;        
               rd_input_strb	            <= 1'b0;			 
               rd_reg_index_reg 	         <= 12'h02F;		 
               wr_reg_strb_reg	         <= 1'b0;			 
               wr_reg_index_reg	         <= 12'h000;		 
               wr_reg_output_reg	         <= 32'h00000000;
               async_abort_trans_proc_reg <= 1'b1;		 					// need to talk to host controller
            end
            // After the software resets are done, we need to clear the
				// trigger bits.
				st_clr_sftw_rst_bits : begin										// 080
					state                      <= st_clr_sftw_rst_bits_wt;
               //<outputs> <= <values>;   
               iss_abrt_cmd_reg           <= 1'b0;        
               rd_input_strb	            <= 1'b0;			 
               rd_reg_index_reg 	         <= 12'h000;		 
               wr_reg_strb_reg	         <= 1'b1;							// Set strobe.		 
               wr_reg_index_reg	         <= 12'h02F;		 
               wr_reg_output_reg	         <= 32'h00000000;				// Reset the trigger bits.
               async_abort_trans_proc_reg <= 1'b1;    					// need to talk to host controller		 
            end
				// Wait here for six clocks.
            st_clr_sftw_rst_bits_wt : begin		 				 			// 100
               if (read_clks_tout)
                  state 				      <= st_end;
               else if (!read_clks_tout)										
						state 	               <= st_clr_sftw_rst_bits_wt;// Now go see if the reset is done.
               else                 
                  state 				      <= st_strt;	
                  //<outputs> <= <values>;
               iss_abrt_cmd_reg           <= 1'b0;     
               rd_input_strb	            <= 1'b0;		
               rd_reg_index_reg    	      <= 12'h000;	
               wr_reg_strb_reg	         <= 1'b0;		
               wr_reg_index_reg	         <= 12'h02F;	
               wr_reg_output_reg   	      <= 32'h00000000;
               async_abort_trans_proc_reg <= 1'b1;							// need to talk to host controller 
            end
				st_end : begin															// 200
               state                      <= st_strt;
               //<outputs> <= <values>;
               iss_abrt_cmd_reg           <= 1'b0;        
               rd_input_strb	            <= 1'b0;			 
               rd_reg_index_reg 	         <= 12'h000;		 
               wr_reg_strb_reg	         <= 1'b0;			 
               wr_reg_index_reg	         <= 12'h000;		 
               wr_reg_output_reg	         <= 32'h00000000;
               async_abort_trans_proc_reg <= 1'b0;		 
            end
            default: begin  														// Fault Recovery
               state                      <= st_strt;
               //<outputs> <= <values>;
               iss_abrt_cmd_reg           <= 1'b0;        
               rd_input_strb	            <= 1'b0;			 
               rd_reg_index_reg 	         <= 12'h000;		 
               wr_reg_strb_reg	         <= 1'b0;			 
               wr_reg_index_reg	         <= 12'h000;		 
               wr_reg_output_reg	         <= 32'h00000000;
               async_abort_trans_proc_reg <= 1'b0;		 
            end
         endcase
						

endmodule
