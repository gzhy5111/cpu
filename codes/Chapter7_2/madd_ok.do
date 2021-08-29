onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/aluop_i
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/cnt_i
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/hilo_temp_i
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/hi
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/lo
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/hilo_temp1
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/hi_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/lo_o
add wave -noupdate -expand /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile0/regs
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/hilo_reg0/hi_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/hilo_reg0/lo_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {397904 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 110
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
WaveRestoreZoom {220494 ps} {828048 ps}
