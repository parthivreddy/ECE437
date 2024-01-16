onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ALU_tb/CLK
add wave -noupdate /ALU_tb/CLK
add wave -noupdate /ALU_tb/CLK
add wave -noupdate /ALU_tb/PROG/testType
add wave -noupdate /ALU_tb/alu/ov
add wave -noupdate /ALU_tb/alu/neg
add wave -noupdate /ALU_tb/alu/zero
add wave -noupdate /ALU_tb/alu/op
add wave -noupdate /ALU_tb/alu/port_a
add wave -noupdate /ALU_tb/alu/port_b
add wave -noupdate /ALU_tb/alu/ALU_output
add wave -noupdate /ALU_tb/DUT/bSigned
add wave -noupdate /ALU_tb/DUT/aSigned
add wave -noupdate /ALU_tb/DUT/ovTest
add wave -noupdate /ALU_tb/DUT/negTest
add wave -noupdate /ALU_tb/DUT/zeroTest
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {350 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1 us}
