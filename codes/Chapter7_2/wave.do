onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/clk
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ctrl0/ex_suspend_signal
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ctrl0/ctrl_signal
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id_ex0/id_aluop
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id_ex0/ex_aluop
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/aluop_i
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/cnt_i
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/hilo_temp_i
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/hilo_temp1
add wave -noupdate -expand /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile0/regs
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/hi
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/lo
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {310148 ps} 0}
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
WaveRestoreZoom {239995 ps} {553683 ps}
