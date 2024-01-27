onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -group syif /system_tb/syif/tbCTRL
add wave -noupdate -group syif /system_tb/syif/halt
add wave -noupdate -group syif /system_tb/syif/WEN
add wave -noupdate -group syif /system_tb/syif/REN
add wave -noupdate -group syif /system_tb/syif/addr
add wave -noupdate -group syif /system_tb/syif/store
add wave -noupdate -group syif /system_tb/syif/load
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/alif/neg
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/alif/ov
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/alif/zero
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/alif/op
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/alif/port_a
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/alif/port_b
add wave -noupdate -expand -group ALU /system_tb/DUT/CPU/DP/alif/ALU_output
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
add wave -noupdate -expand -group ControlUnit /system_tb/DUT/CPU/DP/ctif/Halt
add wave -noupdate -expand -group ControlUnit /system_tb/DUT/CPU/DP/ctif/ALUCtrl
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP/dpif/imemREN
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP/dpif/datomic
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP/dpif/dmemREN
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP/dpif/flushed
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate -group DataPath /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/RF/arrFF
add wave -noupdate -expand -group RegFile /system_tb/DUT/CPU/DP/RF/arr
add wave -noupdate -expand -group RequestUnit /system_tb/DUT/CPU/DP/rqif/ihit
add wave -noupdate -expand -group RequestUnit /system_tb/DUT/CPU/DP/rqif/dhit
add wave -noupdate -expand -group RequestUnit /system_tb/DUT/CPU/DP/rqif/MemRead
add wave -noupdate -expand -group RequestUnit /system_tb/DUT/CPU/DP/rqif/MemWrite
add wave -noupdate -expand -group RequestUnit /system_tb/DUT/CPU/DP/rqif/imemREN
add wave -noupdate -expand -group RequestUnit /system_tb/DUT/CPU/DP/rqif/dmemREN
add wave -noupdate -expand -group RequestUnit /system_tb/DUT/CPU/DP/rqif/dmemWEN
add wave -noupdate -group MemControl /system_tb/DUT/CPU/cif0/iwait
add wave -noupdate -group MemControl /system_tb/DUT/CPU/cif0/dwait
add wave -noupdate -group MemControl /system_tb/DUT/CPU/cif0/iREN
add wave -noupdate -group MemControl /system_tb/DUT/CPU/cif0/dREN
add wave -noupdate -group MemControl /system_tb/DUT/CPU/cif0/dWEN
add wave -noupdate -group MemControl /system_tb/DUT/CPU/cif0/iload
add wave -noupdate -group MemControl /system_tb/DUT/CPU/cif0/dload
add wave -noupdate -group MemControl /system_tb/DUT/CPU/cif0/dstore
add wave -noupdate -group MemControl /system_tb/DUT/CPU/cif0/iaddr
add wave -noupdate -group MemControl /system_tb/DUT/CPU/cif0/daddr
add wave -noupdate -group MemControl /system_tb/DUT/CPU/cif0/ccwait
add wave -noupdate -group MemControl /system_tb/DUT/CPU/cif0/ccinv
add wave -noupdate -group MemControl /system_tb/DUT/CPU/cif0/ccwrite
add wave -noupdate -group MemControl /system_tb/DUT/CPU/cif0/cctrans
add wave -noupdate -group MemControl /system_tb/DUT/CPU/cif0/ccsnoopaddr
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate -expand -group RAM -radix hexadecimal /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memREN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memWEN
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memaddr
add wave -noupdate -expand -group RAM /system_tb/DUT/RAM/ramif/memstore
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {43563 ps} 0}
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
WaveRestoreZoom {27 ns} {292 ns}
