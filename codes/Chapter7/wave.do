onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile0/rst
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile0/clk
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/reg1_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/reg2_o
add wave -noupdate -expand /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile0/regs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {234129 ps} 0}
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
WaveRestoreZoom {421450 ps} {578294 ps}
