onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /control_unit_tb/PROG/testType
add wave -noupdate /control_unit_tb/PROG/subTest
add wave -noupdate /control_unit_tb/nRST
add wave -noupdate /control_unit_tb/CLK
add wave -noupdate /control_unit_tb/ctif/opcode
add wave -noupdate /control_unit_tb/ctif/func
add wave -noupdate /control_unit_tb/ctif/MemRead
add wave -noupdate /control_unit_tb/ctif/MemWrite
add wave -noupdate /control_unit_tb/ctif/RegDst
add wave -noupdate /control_unit_tb/ctif/ExtOp
add wave -noupdate /control_unit_tb/ctif/ALUSrc
add wave -noupdate /control_unit_tb/ctif/RegWr
add wave -noupdate /control_unit_tb/ctif/MemtoReg
add wave -noupdate /control_unit_tb/ctif/Beq
add wave -noupdate /control_unit_tb/ctif/Bne
add wave -noupdate /control_unit_tb/ctif/Jump
add wave -noupdate /control_unit_tb/ctif/Link
add wave -noupdate /control_unit_tb/ctif/LUI
add wave -noupdate /control_unit_tb/ctif/Halt
add wave -noupdate /control_unit_tb/ctif/ALUCtrl
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {100 ns} 0}
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
WaveRestoreZoom {0 ns} {980 ns}
