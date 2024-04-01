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
add wave -noupdate -color Aquamarine /dcache_tb/cif/ccwait
add wave -noupdate -color Aquamarine /dcache_tb/cif/ccinv
add wave -noupdate -color Aquamarine /dcache_tb/cif/ccwrite
add wave -noupdate -color Aquamarine /dcache_tb/cif/cctrans
add wave -noupdate -color Aquamarine /dcache_tb/cif/ccsnoopaddr
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
add wave -noupdate -expand -subitemconfig {{/dcache_tb/DUT/dcache[1]} {-color Yellow -height 16 -expand} {/dcache_tb/DUT/dcache[1][7]} {-color Yellow} {/dcache_tb/DUT/dcache[1][6]} {-color Yellow} {/dcache_tb/DUT/dcache[1][5]} {-color Yellow} {/dcache_tb/DUT/dcache[1][4]} {-color Yellow} {/dcache_tb/DUT/dcache[1][3]} {-color Yellow} {/dcache_tb/DUT/dcache[1][2]} {-color Yellow} {/dcache_tb/DUT/dcache[1][1]} {-color Yellow} {/dcache_tb/DUT/dcache[1][0]} {-color Yellow} {/dcache_tb/DUT/dcache[0]} -expand} /dcache_tb/DUT/dcache
add wave -noupdate /dcache_tb/DUT/ndcache
add wave -noupdate -radix binary /dcache_tb/DUT/LRU
add wave -noupdate -radix binary /dcache_tb/DUT/nLRU
add wave -noupdate /dcache_tb/DUT/endSet
add wave -noupdate /dcache_tb/DUT/index
add wave -noupdate /dcache_tb/DUT/nIndex
add wave -noupdate -expand /dcache_tb/DUT/addr
add wave -noupdate /dcache_tb/DUT/currState
add wave -noupdate /dcache_tb/DUT/nState
add wave -noupdate -color Salmon /dcache_tb/DUT/firstSt
add wave -noupdate -color Salmon /dcache_tb/DUT/nfirstSt
add wave -noupdate /dcache_tb/DUT/WENfirst
add wave -noupdate /dcache_tb/DUT/RENfirst
add wave -noupdate /dcache_tb/PROG/testType
add wave -noupdate /dcache_tb/PROG/inReset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {545 ns} 0}
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
WaveRestoreZoom {524 ns} {650 ns}
