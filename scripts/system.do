onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/DUT/CPU/nRST
add wave -noupdate -divider Core0
add wave -noupdate -group ControlUnit /system_tb/DUT/CPU/DP0/ctif/opcode
add wave -noupdate -group ControlUnit /system_tb/DUT/CPU/DP0/ctif/func
add wave -noupdate -group ControlUnit /system_tb/DUT/CPU/DP0/ctif/ALUCtrl
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif0/halt
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif0/ihit
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif0/imemREN
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif0/imemload
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif0/imemaddr
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif0/dhit
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif0/dmemREN
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif0/dmemWEN
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif0/dmemload
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif0/dmemstore
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif0/dmemaddr
add wave -noupdate -group stages -label stage1|IF/ID /system_tb/DUT/CPU/DP0/stage1
add wave -noupdate -group stages -label stage2|ID/EX /system_tb/DUT/CPU/DP0/stage2
add wave -noupdate -group stages -label stage3|EX/MEM /system_tb/DUT/CPU/DP0/stage3
add wave -noupdate -group stages -label stage4|MEM/WB /system_tb/DUT/CPU/DP0/stage4
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP0/RF/arr
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP0/RF/arrFF
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP1/rfif/WEN
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP1/rfif/wsel
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP1/rfif/rsel1
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP1/rfif/rsel2
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP1/rfif/wdat
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP1/rfif/rdat1
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP1/rfif/rdat2
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP0/alif/neg
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP0/alif/ov
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP0/alif/zero
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP0/alif/op
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP0/alif/port_a
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP0/alif/port_b
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP0/alif/ALU_output
add wave -noupdate -group ForwardUnit /system_tb/DUT/CPU/DP0/fuif/stage2_rs
add wave -noupdate -group ForwardUnit /system_tb/DUT/CPU/DP0/fuif/stage2_rt
add wave -noupdate -group ForwardUnit /system_tb/DUT/CPU/DP0/fuif/stage3_rd
add wave -noupdate -group ForwardUnit /system_tb/DUT/CPU/DP0/fuif/stage4_rd
add wave -noupdate -group ForwardUnit /system_tb/DUT/CPU/DP0/fuif/stage3_RegWr
add wave -noupdate -group ForwardUnit /system_tb/DUT/CPU/DP0/fuif/stage4_RegWr
add wave -noupdate -group ForwardUnit /system_tb/DUT/CPU/DP0/fuif/stage2_MemWr
add wave -noupdate -group ForwardUnit /system_tb/DUT/CPU/DP0/fuif/forwardA
add wave -noupdate -group ForwardUnit /system_tb/DUT/CPU/DP0/fuif/forwardB
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP0/huif/jump
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP0/huif/branch
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP0/huif/flush1
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP0/huif/flush2
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP0/huif/flush3
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP0/huif/stall
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP0/huif/stage2_MemRead
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP0/huif/jr
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP0/huif/stage3_MemRead
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP0/huif/stage3_MemWrite
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP0/huif/stall_all
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP0/huif/ihit
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP0/huif/stage1_rs
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP0/huif/stage1_rt
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP0/huif/stage2_rt
add wave -noupdate -group icache /system_tb/DUT/CPU/cif0/iwait
add wave -noupdate -group icache /system_tb/DUT/CPU/cif0/iload
add wave -noupdate -group icache /system_tb/DUT/CPU/cif0/iaddr
add wave -noupdate -group icache /system_tb/DUT/CPU/CM0/ICACHE/cache
add wave -noupdate -group icache /system_tb/DUT/CPU/CM0/ICACHE/ncache
add wave -noupdate -group icache /system_tb/DUT/CPU/CM0/ICACHE/addr
add wave -noupdate -group icache /system_tb/DUT/CPU/CM0/ICACHE/currState
add wave -noupdate -group icache /system_tb/DUT/CPU/CM0/ICACHE/nState
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM0/DCACHE/firstSt
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM0/DCACHE/nfirstSt
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM0/DCACHE/WENfirst
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM0/DCACHE/currState
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM0/DCACHE/nState
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM0/DCACHE/dcache
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM0/DCACHE/ndcache
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM0/DCACHE/LRU
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM0/DCACHE/nLRU
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif0/dwait
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif0/dWEN
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif0/dREN
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif0/dload
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif0/dstore
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif0/daddr
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif0/ccsnoopaddr
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif0/ccwait
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif0/ccwrite
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif0/cctrans
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif0/ccinv
add wave -noupdate -divider MemController
add wave -noupdate -group MemCTRL /system_tb/DUT/CPU/CC/state
add wave -noupdate -group MemCTRL /system_tb/DUT/CPU/CC/nstate
add wave -noupdate -group MemCTRL /system_tb/DUT/CPU/CC/core
add wave -noupdate -group MemCTRL /system_tb/DUT/CPU/ccif/ccwait
add wave -noupdate -group MemCTRL /system_tb/DUT/CPU/ccif/ccinv
add wave -noupdate -group MemCTRL /system_tb/DUT/CPU/ccif/ccwrite
add wave -noupdate -group MemCTRL /system_tb/DUT/CPU/ccif/cctrans
add wave -noupdate -group MemCTRL /system_tb/DUT/CPU/ccif/ccsnoopaddr
add wave -noupdate -group MemCTRL /system_tb/DUT/CPU/ccif/ramWEN
add wave -noupdate -group MemCTRL /system_tb/DUT/CPU/ccif/ramREN
add wave -noupdate -group MemCTRL /system_tb/DUT/CPU/ccif/ramstate
add wave -noupdate -group MemCTRL /system_tb/DUT/CPU/ccif/ramaddr
add wave -noupdate -group MemCTRL /system_tb/DUT/CPU/ccif/ramstore
add wave -noupdate -group MemCTRL /system_tb/DUT/CPU/ccif/ramload
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -divider Core1
add wave -noupdate -group ControlUnit /system_tb/DUT/CPU/DP1/ctif/opcode
add wave -noupdate -group ControlUnit /system_tb/DUT/CPU/DP1/ctif/func
add wave -noupdate -group ControlUnit /system_tb/DUT/CPU/DP1/ctif/ALUCtrl
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif1/halt
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif1/ihit
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif1/imemREN
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif1/imemload
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif1/imemaddr
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif1/dhit
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif1/dmemREN
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif1/dmemWEN
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif1/dmemload
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif1/dmemstore
add wave -noupdate -group DataPath /system_tb/DUT/CPU/dcif1/dmemaddr
add wave -noupdate -group stages /system_tb/DUT/CPU/DP1/stage1
add wave -noupdate -group stages /system_tb/DUT/CPU/DP1/stage2
add wave -noupdate -group stages /system_tb/DUT/CPU/DP1/stage3
add wave -noupdate -group stages /system_tb/DUT/CPU/DP1/stage4
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP1/RF/arr
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP1/RF/arrFF
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP1/rfif/WEN
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP1/rfif/wsel
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP1/rfif/rsel1
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP1/rfif/rsel2
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP1/rfif/wdat
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP1/rfif/rdat1
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP1/rfif/rdat2
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP1/alif/neg
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP1/alif/ov
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP1/alif/zero
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP1/alif/op
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP1/alif/port_a
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP1/alif/port_b
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP1/alif/ALU_output
add wave -noupdate -group ALU -group ControlUnit /system_tb/DUT/CPU/DP1/ctif/opcode
add wave -noupdate -group ALU -group ControlUnit /system_tb/DUT/CPU/DP1/ctif/func
add wave -noupdate -group ALU -group ControlUnit /system_tb/DUT/CPU/DP1/ctif/ALUCtrl
add wave -noupdate -group ForwardUnit /system_tb/DUT/CPU/DP1/fuif/stage2_rs
add wave -noupdate -group ForwardUnit /system_tb/DUT/CPU/DP1/fuif/stage2_rt
add wave -noupdate -group ForwardUnit /system_tb/DUT/CPU/DP1/fuif/stage3_rd
add wave -noupdate -group ForwardUnit /system_tb/DUT/CPU/DP1/fuif/stage4_rd
add wave -noupdate -group ForwardUnit /system_tb/DUT/CPU/DP1/fuif/stage3_RegWr
add wave -noupdate -group ForwardUnit /system_tb/DUT/CPU/DP1/fuif/stage4_RegWr
add wave -noupdate -group ForwardUnit /system_tb/DUT/CPU/DP1/fuif/stage2_MemWr
add wave -noupdate -group ForwardUnit /system_tb/DUT/CPU/DP1/fuif/forwardA
add wave -noupdate -group ForwardUnit /system_tb/DUT/CPU/DP1/fuif/forwardB
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP1/huif/jump
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP1/huif/branch
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP1/huif/flush1
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP1/huif/flush2
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP1/huif/flush3
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP1/huif/stall
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP1/huif/stage2_MemRead
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP1/huif/jr
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP1/huif/stage3_MemRead
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP1/huif/stage3_MemWrite
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP1/huif/stall_all
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP1/huif/ihit
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP1/huif/stage1_rs
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP1/huif/stage1_rt
add wave -noupdate -group HazardUnit /system_tb/DUT/CPU/DP1/huif/stage2_rt
add wave -noupdate -group icache /system_tb/DUT/CPU/cif1/iwait
add wave -noupdate -group icache /system_tb/DUT/CPU/cif1/iload
add wave -noupdate -group icache /system_tb/DUT/CPU/cif1/iaddr
add wave -noupdate -group icache /system_tb/DUT/CPU/CM1/ICACHE/cache
add wave -noupdate -group icache /system_tb/DUT/CPU/CM1/ICACHE/ncache
add wave -noupdate -group icache /system_tb/DUT/CPU/CM1/ICACHE/addr
add wave -noupdate -group icache /system_tb/DUT/CPU/CM1/ICACHE/currState
add wave -noupdate -group icache /system_tb/DUT/CPU/CM1/ICACHE/nState
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM1/DCACHE/firstSt
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM1/DCACHE/nfirstSt
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM1/DCACHE/WENfirst
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM1/DCACHE/currState
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM1/DCACHE/nState
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM1/DCACHE/dcache
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM1/DCACHE/ndcache
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM1/DCACHE/LRU
add wave -noupdate -group dcache /system_tb/DUT/CPU/CM1/DCACHE/nLRU
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif1/dwait
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif1/dREN
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif1/dWEN
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif1/dload
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif1/dstore
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif1/daddr
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif1/ccwait
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif1/ccinv
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif1/ccwrite
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif1/cctrans
add wave -noupdate -group dcache /system_tb/DUT/CPU/cif1/ccsnoopaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {85471 ps} 0}
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
