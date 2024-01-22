onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /memory_control_tb/PROG/testNum
add wave -noupdate /memory_control_tb/PROG/testType
add wave -noupdate /memory_control_tb/CLK
add wave -noupdate /memory_control_tb/nRST
add wave -noupdate -group cache /memory_control_tb/cache/iwait
add wave -noupdate -group cache /memory_control_tb/cache/dwait
add wave -noupdate -group cache /memory_control_tb/cache/iREN
add wave -noupdate -group cache /memory_control_tb/cache/dREN
add wave -noupdate -group cache /memory_control_tb/cache/dWEN
add wave -noupdate -group cache /memory_control_tb/cache/iload
add wave -noupdate -group cache /memory_control_tb/cache/dload
add wave -noupdate -group cache /memory_control_tb/cache/dstore
add wave -noupdate -group cache /memory_control_tb/cache/iaddr
add wave -noupdate -group cache /memory_control_tb/cache/daddr
add wave -noupdate -group cache /memory_control_tb/cache/ccwait
add wave -noupdate -group cache /memory_control_tb/cache/ccinv
add wave -noupdate -group cache /memory_control_tb/cache/ccwrite
add wave -noupdate -group cache /memory_control_tb/cache/cctrans
add wave -noupdate -group cache /memory_control_tb/cache/ccsnoopaddr
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/iwait
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/dwait
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/iREN
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/dREN
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/dWEN
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/iload
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/dload
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/dstore
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/iaddr
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/daddr
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/ccwait
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/ccinv
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/ccwrite
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/cctrans
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/ccsnoopaddr
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/ramWEN
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/ramREN
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/ramstate
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/ramaddr
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/ramstore
add wave -noupdate -expand -group memoryCNT /memory_control_tb/ccif/ramload
add wave -noupdate -group ram /memory_control_tb/ramif/ramREN
add wave -noupdate -group ram /memory_control_tb/ramif/ramWEN
add wave -noupdate -group ram /memory_control_tb/ramif/ramaddr
add wave -noupdate -group ram /memory_control_tb/ramif/ramstore
add wave -noupdate -group ram /memory_control_tb/ramif/ramload
add wave -noupdate -group ram /memory_control_tb/ramif/ramstate
add wave -noupdate -group ram /memory_control_tb/ramif/memREN
add wave -noupdate -group ram /memory_control_tb/ramif/memWEN
add wave -noupdate -group ram /memory_control_tb/ramif/memaddr
add wave -noupdate -group ram /memory_control_tb/ramif/memstore
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
WaveRestoreZoom {0 ps} {1 us}
