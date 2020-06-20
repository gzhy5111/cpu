onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/clk
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/rst
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/rom_ce
add wave -noupdate -radix decimal -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/if_id0/if_pc
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/if_id0/if_inst
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/if_id0/id_pc
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/if_id0/id_inst
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/aluop_o
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/alusel_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/wd_o
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/wreg_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/reg1_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/id0/reg2_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/wd_o
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/wreg_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/ex0/wdata_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem0/wd_o
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem0/wreg_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem0/wdata_o
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem_wb0/wb_wd
add wave -noupdate -radix binary -radixshowbase 0 /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem_wb0/wb_wreg
add wave -noupdate /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/mem_wb0/wb_wdata
add wave -noupdate -expand /openmips_min_sopc_tb/openmips_min_sopc0/openmips0/regfile0/regs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {开始取指 {210128 ps} 1} {开始译码 {230000 ps} 1} {开始执行 {250000 ps} 1} {开始访存 {269927 ps} 1} {开始回写 {289944 ps} 1} {开始写回寄存器堆 {310214 ps} 1}
quietly wave cursor active 6
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
WaveRestoreZoom {169587 ps} {483275 ps}
