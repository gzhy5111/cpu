onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/clk
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/rst
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/reg1_i
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/reg2_i
add wave -noupdate -expand /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile0/regs
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/hi_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/lo_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/hilo_reg0/hi_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/hilo_reg0/lo_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {第四段开始 {990004 ps} 1} {{Cursor 2} {1111117 ps} 0}
quietly wave cursor active 2
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
WaveRestoreZoom {978939 ps} {1135783 ps}
