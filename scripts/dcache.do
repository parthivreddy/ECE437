onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/nRST
add wave -noupdate /dcache_tb/CLK
add wave -noupdate -divider {Memory Side}
add wave -noupdate /dcache_tb/cif/dwait
add wave -noupdate /dcache_tb/cif/dREN
add wave -noupdate /dcache_tb/cif/dWEN
add wave -noupdate /dcache_tb/cif/dload
add wave -noupdate /dcache_tb/cif/dstore
add wave -noupdate /dcache_tb/cif/daddr
add wave -noupdate -divider {Datapath Side}
add wave -noupdate /dcache_tb/dcif/halt
add wave -noupdate /dcache_tb/dcif/dhit
add wave -noupdate /dcache_tb/dcif/datomic
add wave -noupdate /dcache_tb/dcif/dmemREN
add wave -noupdate /dcache_tb/dcif/dmemWEN
add wave -noupdate /dcache_tb/dcif/flushed
add wave -noupdate /dcache_tb/dcif/dmemload
add wave -noupdate /dcache_tb/dcif/dmemstore
add wave -noupdate /dcache_tb/dcif/dmemaddr
add wave -noupdate -divider {Internal Registers}
add wave -noupdate /dcache_tb/DUT/CLK
add wave -noupdate /dcache_tb/DUT/nRST
add wave -noupdate -expand -subitemconfig {{/dcache_tb/DUT/dcache[0]} -expand} /dcache_tb/DUT/dcache
add wave -noupdate /dcache_tb/DUT/ndcache
add wave -noupdate -radix binary /dcache_tb/DUT/LRU
add wave -noupdate -radix binary /dcache_tb/DUT/nLRU
add wave -noupdate /dcache_tb/DUT/endSet
add wave -noupdate /dcache_tb/DUT/index
add wave -noupdate /dcache_tb/DUT/nIndex
add wave -noupdate /dcache_tb/DUT/addr
add wave -noupdate /dcache_tb/DUT/currState
add wave -noupdate /dcache_tb/DUT/nState
add wave -noupdate /dcache_tb/PROG/testType
add wave -noupdate /dcache_tb/PROG/inReset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {72 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 286
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
WaveRestoreZoom {55 ns} {181 ns}
