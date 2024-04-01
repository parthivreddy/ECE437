onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group ControlUnit /system_tb/DUT/CPU/DP0/ctif/opcode
add wave -noupdate -group ControlUnit /system_tb/DUT/CPU/DP0/ctif/func
add wave -noupdate -group ControlUnit /system_tb/DUT/CPU/DP0/ctif/ALUCtrl
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP0/dpif/halt
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP0/dpif/ihit
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP0/dpif/imemREN
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP0/dpif/imemload
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP0/dpif/imemaddr
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP0/dpif/dhit
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP0/dpif/dmemREN
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP0/dpif/dmemWEN
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP0/dpif/dmemload
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP0/dpif/dmemstore
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP0/dpif/dmemaddr
add wave -noupdate /system_tb/DUT/CPU/DP0/stage1
add wave -noupdate /system_tb/DUT/CPU/DP0/stage2
add wave -noupdate /system_tb/DUT/CPU/DP0/stage3
add wave -noupdate /system_tb/DUT/CPU/DP0/stage4
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
WaveRestoreCursors {{Cursor 1} {62774 ps} 0}
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
WaveRestoreZoom {0 ps} {265 ns}
