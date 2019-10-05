# sdc_do_file.do
# On the command line type:
# c:\work> vsim -do sdc_do_file.do
# c:\work> being where your work files are located.

# This is the do file for the sdc controller.
#vsim -novopt work.sdc_controller_mod
vsim -novopt work.sdc_controller_mod_tb2
#vsim -vopt work.sdc_controller_mod_tb2


#add wave -position end sim:/sdc_controller_mod/clk
#add wave -position end sim:/sdc_controller_mod/fifo_data
#add wave -position end sim:/sdc_controller_mod/host_tst_cmd_strb
#add wave -position end sim:/sdc_controller_mod/man_init_sdc_strb
#add wave -position end sim:/sdc_controller_mod/rd_reg_indx_puc
#add wave -position end sim:/sdc_controller_mod/rd_reg_output_puc
#add wave -position end sim:/sdc_controller_mod/rdy_for_nxt_pkt

# For sdc_controller_mod
add wave -position insertpoint sim:/sdc_controller_mod_tb2/rd_reg_output_puc
add wave -position insertpoint sim:/sdc_controller_mod_tb2/strt_fifo_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/rdy_for_nxt_pkt
add wave -position insertpoint sim:/sdc_controller_mod_tb2/clk
add wave -position insertpoint sim:/sdc_controller_mod_tb2/reset
add wave -position insertpoint sim:/sdc_controller_mod_tb2/man_init_sdc_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/host_tst_cmd_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/rd_reg_indx_puc
add wave -position insertpoint sim:/sdc_controller_mod_tb2/wr_reg_man
add wave -position insertpoint sim:/sdc_controller_mod_tb2/wreg_sdc_hc_reg_man
add wave -position insertpoint sim:/sdc_controller_mod_tb2/start_data_tf_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/data_in_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/last_set_of_data_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/data
add wave -position insertpoint sim:/sdc_controller_mod_tb2/wr_b_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/fifo_data
add wave -position insertpoint sim:/sdc_controller_mod_tb2/sdc_rd_addr
add wave -position insertpoint sim:/sdc_controller_mod_tb2/sdc_wr_addr
add wave -position insertpoint sim:/sdc_controller_mod_tb2/tf_mode
add wave -position insertpoint sim:/sdc_controller_mod_tb2/IO_SDC1_CMD_out
add wave -position insertpoint sim:/sdc_controller_mod_tb2/IO_SDC1_CMD_in
# For host controller
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/command
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/present_state
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/normal_int_status
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/clk
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/transfer_mode
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/strt_adma_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/strt_snd_data_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/new_dat_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/sm_rd_data
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/fifo_rdy_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/D0_in
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/D0_out
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/SDC_CLK
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/wr_reg_index
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/wr_reg_strb_z1
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/new_resp_pkt_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/new_resp_pkt_strb_z1
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/end_bit_det_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/end_bit_det_strb_z1
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/end_descr
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/wr_busy
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/wr_busy_z1
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/des_fifo_rd_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/des_fifo_rd_strb_z5
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/des_rd_data
# hc/snd_dat
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/sdc_snd_dat_1_bit_u10/oe_reg
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/sdc_snd_dat_1_bit_u10/sm_rd_data
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/sdc_snd_dat_1_bit_u10/bit_out_cntr
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/sdc_snd_dat_1_bit_u10/fin_dat_out
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/sdc_snd_dat_1_bit_u10/new_dat_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/sdc_snd_dat_1_bit_u10/nxt_dat_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/sdc_snd_dat_1_bit_u10/strt_snd_data_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/sdc_snd_dat_1_bit_u10/strt_snd_data_strb_z1
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/sdc_snd_dat_1_bit_u10/strt_snd_data_strb_z2
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/sdc_snd_dat_1_bit_u10/dataWrdCnt
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/sdc_snd_dat_1_bit_u10/pkt_crc
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/sdc_snd_dat_1_bit_u10/fin_all_dat_strb
# newDatSetCntr
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/sdc_snd_dat_1_bit_u10/newDatSetCntr/cntr
# For adma2_fsm
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/adma2_fsm_u2/state
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/adma2_fsm_u2/strt_wait_cntr
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_controller_u2/adma2_fsm_u2/done_wait_strb
# For host bus driver
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_bus_driver_u1/wr_b_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_bus_driver_u1/wr_b_strb_z1
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_bus_driver_u1/wr_b_strb_z2
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_bus_driver_u1/stop_recv_pkt
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_bus_driver_u1/blocks_crc_done_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_bus_driver_u1/str_crc_strb
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_bus_driver_u1/str_crc_strb_z1
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_bus_driver_u1/str_crc_strb_z2
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_bus_driver_u1/str_crc_strb_z3
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_bus_driver_u1/sm_wr_addr
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_bus_driver_u1/sm_rd_addr
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_bus_driver_u1/datain
# For data_tf_using_adma_u8
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_bus_driver_u1/data_tf_using_adma_u8/state
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_bus_driver_u1/data_tf_using_adma_u8/tf_complete
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_bus_driver_u1/data_tf_using_adma_u8/rd_reg_input
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_bus_driver_u1/data_tf_using_adma_u8/normal_int_stat_bit_1
add wave -position insertpoint sim:/sdc_controller_mod_tb2/uut/sd_host_bus_driver_u1/data_tf_using_adma_u8/normal_int_stat_bit_1_z1

#add wave -recursive -depth 3 *

# Create the system clock.
#force -freeze sim:/sdc_controller_mod/clk 1 0, 0 {10 ns} -r 20 ns
run 460 ms
