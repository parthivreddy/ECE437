onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /request_unit_tb/nRST
add wave -noupdate /request_unit_tb/CLK
add wave -noupdate /request_unit_tb/rqif/ihit
add wave -noupdate /request_unit_tb/rqif/dhit
add wave -noupdate /request_unit_tb/rqif/MemRead
add wave -noupdate /request_unit_tb/rqif/MemWrite
add wave -noupdate /request_unit_tb/rqif/imemREN
add wave -noupdate /request_unit_tb/rqif/dmemREN
add wave -noupdate /request_unit_tb/rqif/dmemWEN
add wave -noupdate /request_unit_tb/DUT/nDmemWEN
add wave -noupdate /request_unit_tb/DUT/nDmemREN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
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
