onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /forward_unit_tb/PROG/testType
add wave -noupdate /forward_unit_tb/nRST
add wave -noupdate /forward_unit_tb/CLK
add wave -noupdate /forward_unit_tb/fuif/stage2_rs
add wave -noupdate /forward_unit_tb/fuif/stage2_rt
add wave -noupdate /forward_unit_tb/fuif/stage3_rd
add wave -noupdate /forward_unit_tb/fuif/stage4_rd
add wave -noupdate /forward_unit_tb/fuif/stage3_RegWr
add wave -noupdate /forward_unit_tb/fuif/stage4_RegWr
add wave -noupdate /forward_unit_tb/fuif/stage2_MemWr
add wave -noupdate /forward_unit_tb/fuif/forwardA
add wave -noupdate /forward_unit_tb/fuif/forwardB
add wave -noupdate /forward_unit_tb/PROG/check_outputs/checkA
add wave -noupdate /forward_unit_tb/PROG/check_outputs/checkB
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {24 ns} 0}
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
WaveRestoreZoom {3 ns} {65 ns}
