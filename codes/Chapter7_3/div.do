onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/div_fsm0/clk
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/aluop_i
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/reg1_i
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/reg2_i
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/div_start_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/div_data1_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/div_data2_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/div_fsm0/ready
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/div_fsm0/en
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/div_fsm0/dividend
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/div_fsm0/divisor
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/div_cnt_i
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/div_ready_i
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/div_shang_i
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/div_yushu_i
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/shang
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/yushu
add wave -noupdate -expand /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile0/regs
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/hilo_reg0/hi_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/hilo_reg0/lo_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {350000 ps} 1} {{Cursor 2} {710344 ps} 1} {{Cursor 3} {799597 ps} 0}
quietly wave cursor active 3
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
WaveRestoreZoom {218368 ps} {845744 ps}
