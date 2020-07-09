onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/clk
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/rst
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/rom_ce_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/if_id0/if_pc
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/if_id0/if_inst
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/if_id0/id_pc
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/if_id0/id_inst
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/aluop_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/alusel_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/wd_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/wreg_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/reg1_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/reg2_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/wd_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/wreg_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/wdata_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem0/wd_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem0/wreg_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem0/wdata_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem_wb0/wb_wd
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem_wb0/wb_wreg
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem_wb0/wb_wdata
add wave -noupdate -expand /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile0/regs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {309757 ps} 0}
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
WaveRestoreZoom {158741 ps} {472429 ps}
