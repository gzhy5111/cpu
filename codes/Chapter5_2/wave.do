onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/clk
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/rst
add wave -noupdate -radix decimal -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/pc
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/if_id0/id_pc
add wave -noupdate -radix decimal -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/if_id0/if_pc
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/if_id0/if_inst
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id_aluop_o
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id_alusel_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id_reg1_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id_reg2_o
add wave -noupdate -radix decimal -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id_wd_o
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id_wreg_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex_wd_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex_wdata_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex_wreg_o
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/reg2_read_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/rom_addr_o
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/rom_ce_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/wb_wd_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/wb_wdata_o
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/wb_wreg_o
add wave -noupdate -expand /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile0/regs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {277440 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {270156 ps} {583844 ps}
