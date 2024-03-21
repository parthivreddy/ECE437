onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/prog
add wave -noupdate -group syif /system_tb/syif/tbCTRL
add wave -noupdate -group syif /system_tb/syif/halt
add wave -noupdate -group syif /system_tb/syif/WEN
add wave -noupdate -group syif /system_tb/syif/REN
add wave -noupdate -group syif /system_tb/syif/addr
add wave -noupdate -group syif /system_tb/syif/store
add wave -noupdate -group syif /system_tb/syif/load
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/alif/neg
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/alif/ov
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/alif/zero
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/alif/op
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/alif/port_a
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/alif/port_b
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/alif/ALU_output
add wave -noupdate -expand -group ControlUnit /system_tb/DUT/CPU/DP/ctif/halt
add wave -noupdate -expand -group ControlUnit /system_tb/DUT/CPU/DP/ctif/opcode
add wave -noupdate -expand -group ControlUnit /system_tb/DUT/CPU/DP/ctif/func
add wave -noupdate -expand -group ControlUnit /system_tb/DUT/CPU/DP/ctif/MemRead
add wave -noupdate -expand -group ControlUnit /system_tb/DUT/CPU/DP/ctif/MemWrite
add wave -noupdate -expand -group ControlUnit /system_tb/DUT/CPU/DP/ctif/RegDst
add wave -noupdate -expand -group ControlUnit /system_tb/DUT/CPU/DP/ctif/ExtOp
add wave -noupdate -expand -group ControlUnit /system_tb/DUT/CPU/DP/ctif/ALUSrc
add wave -noupdate -expand -group ControlUnit /system_tb/DUT/CPU/DP/ctif/RegWr
add wave -noupdate -expand -group ControlUnit /system_tb/DUT/CPU/DP/ctif/MemtoReg
add wave -noupdate -expand -group ControlUnit /system_tb/DUT/CPU/DP/ctif/Beq
add wave -noupdate -expand -group ControlUnit /system_tb/DUT/CPU/DP/ctif/Bne
add wave -noupdate -expand -group ControlUnit /system_tb/DUT/CPU/DP/ctif/Jump
add wave -noupdate -expand -group ControlUnit /system_tb/DUT/CPU/DP/ctif/Link
add wave -noupdate -expand -group ControlUnit /system_tb/DUT/CPU/DP/ctif/LUI
add wave -noupdate -expand -group ControlUnit /system_tb/DUT/CPU/DP/ctif/ALUCtrl
add wave -noupdate -expand -group DataPath /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate -expand -group DataPath /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate -expand -group DataPath /system_tb/DUT/CPU/DP/dpif/imemREN
add wave -noupdate -expand -group DataPath /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate -expand -group DataPath /system_tb/DUT/CPU/DP/nPC
add wave -noupdate -expand -group DataPath /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate -expand -group DataPath /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate -expand -group DataPath /system_tb/DUT/CPU/DP/dpif/datomic
add wave -noupdate -expand -group DataPath /system_tb/DUT/CPU/DP/dpif/dmemREN
add wave -noupdate -expand -group DataPath -color Gold /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate -expand -group DataPath /system_tb/DUT/CPU/DP/dpif/flushed
add wave -noupdate -expand -group DataPath /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate -expand -group DataPath /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate -expand -group DataPath /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP/RF/arrFF
add wave -noupdate -group RegFile /system_tb/DUT/CPU/DP/RF/arr
add wave -noupdate -expand -group MemControl -divider icache
add wave -noupdate -expand -group MemControl /system_tb/DUT/CPU/cif0/iwait
add wave -noupdate -expand -group MemControl /system_tb/DUT/CPU/cif0/iREN
add wave -noupdate -expand -group MemControl /system_tb/DUT/CPU/cif0/iload
add wave -noupdate -expand -group MemControl /system_tb/DUT/CPU/cif0/iaddr
add wave -noupdate -expand -group MemControl -divider dcache
add wave -noupdate -expand -group MemControl /system_tb/DUT/CPU/cif0/dwait
add wave -noupdate -expand -group MemControl /system_tb/DUT/CPU/cif0/dREN
add wave -noupdate -expand -group MemControl -color Gold /system_tb/DUT/CPU/cif0/dWEN
add wave -noupdate -expand -group MemControl /system_tb/DUT/CPU/cif0/dload
add wave -noupdate -expand -group MemControl /system_tb/DUT/CPU/cif0/dstore
add wave -noupdate -expand -group MemControl /system_tb/DUT/CPU/cif0/daddr
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate -group RAM -radix hexadecimal /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/memREN
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/memWEN
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/memaddr
add wave -noupdate -group RAM /system_tb/DUT/RAM/ramif/memstore
add wave -noupdate -divider Caches
add wave -noupdate -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/cache
add wave -noupdate -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/ncache
add wave -noupdate -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/addr
add wave -noupdate -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/currState
add wave -noupdate -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/nState
add wave -noupdate -group DCACHE -expand -subitemconfig {{/system_tb/DUT/CPU/CM/DCACHE/dcache[1]} -expand {/system_tb/DUT/CPU/CM/DCACHE/dcache[0]} -expand} /system_tb/DUT/CPU/CM/DCACHE/dcache
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/ndcache
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/LRU
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/nLRU
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/endSet
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/index
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/nIndex
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/hit_counter
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/nhit_counter
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/oldaddr
add wave -noupdate -group DCACHE -expand /system_tb/DUT/CPU/CM/DCACHE/addr
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/currState
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/nState
add wave -noupdate -divider Stages
add wave -noupdate -group stage1/IF_ID /system_tb/DUT/CPU/DP/stage1.PC_plus_four
add wave -noupdate -group stage1/IF_ID /system_tb/DUT/CPU/DP/stage1.instruction
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.halt
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.PC_plus_four
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.rdat1
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.rdat2
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.immExtension
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.LUIdat
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.dest
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.ALUSrc
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.ALUCtrl
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.MemRead
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.MemWrite
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.Jump
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.Beq
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.Bne
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.JR
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.MemtoReg
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.Link
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.LUI
add wave -noupdate -group stage2/ID_EX /system_tb/DUT/CPU/DP/stage2.RegWr
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.halt
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.PC_plus_four
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.rdat1
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.rdat2
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.LUIdat
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.dest
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.branchPC
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.zero
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.ALU_output
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.MemRead
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.MemWrite
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.Jump
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.Beq
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.Bne
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.JR
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.MemtoReg
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.Link
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.LUI
add wave -noupdate -group stage3/EX_MEM /system_tb/DUT/CPU/DP/stage3.RegWr
add wave -noupdate -group stage4/MEM_WB /system_tb/DUT/CPU/DP/stage4.dmemload
add wave -noupdate -group stage4/MEM_WB /system_tb/DUT/CPU/DP/stage4.LUIdat
add wave -noupdate -group stage4/MEM_WB /system_tb/DUT/CPU/DP/stage4.dest
add wave -noupdate -group stage4/MEM_WB /system_tb/DUT/CPU/DP/stage4.PC_plus_four
add wave -noupdate -group stage4/MEM_WB /system_tb/DUT/CPU/DP/stage4.ALU_output
add wave -noupdate -group stage4/MEM_WB /system_tb/DUT/CPU/DP/stage4.MemtoReg
add wave -noupdate -group stage4/MEM_WB /system_tb/DUT/CPU/DP/stage4.Link
add wave -noupdate -group stage4/MEM_WB /system_tb/DUT/CPU/DP/stage4.LUI
add wave -noupdate -group stage4/MEM_WB /system_tb/DUT/CPU/DP/stage4.RegWr
add wave -noupdate /system_tb/DUT/CPU/DP/nstage1
add wave -noupdate /system_tb/DUT/CPU/DP/nstage2
add wave -noupdate /system_tb/DUT/CPU/DP/nstage3
add wave -noupdate /system_tb/DUT/CPU/DP/nstage4
add wave -noupdate -divider Hazards
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/jump
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/stall_all
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/branch
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/flush1
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/flush2
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/stall
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/stage2_MemRead
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/stage1_rs
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/stage1_rt
add wave -noupdate -group {Hazard Unit} /system_tb/DUT/CPU/DP/huif/stage2_rt
add wave -noupdate -group {forward unit} /system_tb/DUT/CPU/DP/fuif/stage2_rs
add wave -noupdate -group {forward unit} /system_tb/DUT/CPU/DP/fuif/stage2_rt
add wave -noupdate -group {forward unit} /system_tb/DUT/CPU/DP/fuif/stage3_rd
add wave -noupdate -group {forward unit} /system_tb/DUT/CPU/DP/fuif/stage4_rd
add wave -noupdate -group {forward unit} /system_tb/DUT/CPU/DP/fuif/stage3_RegWr
add wave -noupdate -group {forward unit} /system_tb/DUT/CPU/DP/fuif/stage4_RegWr
add wave -noupdate -group {forward unit} /system_tb/DUT/CPU/DP/fuif/forwardA
add wave -noupdate -group {forward unit} /system_tb/DUT/CPU/DP/fuif/forwardB
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16360000 ps} 0}
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
WaveRestoreZoom {16227500 ps} {16492500 ps}
