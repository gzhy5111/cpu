onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /openmips_min_sopc_tb/rst
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/clk
add wave -noupdate -expand /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile0/regs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {开始第二段 {609865 ps} 1}
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
WaveRestoreZoom {466703 ps} {780391 ps}
