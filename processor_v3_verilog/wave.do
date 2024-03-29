onerror {resume}
quietly WaveActivateNextPane {} 0
#add wave -noupdate /multicycle_tb/HEX0
#add wave -noupdate /multicycle_tb/HEX1
#add wave -noupdate /multicycle_tb/HEX2
#add wave -noupdate /multicycle_tb/HEX3
#add wave -noupdate /multicycle_tb/HEX4
#add wave -noupdate /multicycle_tb/HEX5
#add wave -noupdate /multicycle_tb/HEX6
#add wave -noupdate /multicycle_tb/HEX7
#add wave -noupdate /multicycle_tb/LEDG
#add wave -noupdate /multicycle_tb/LEDR
#add wave -noupdate /multicycle_tb/KEY
#add wave -noupdate /multicycle_tb/SW
#add wave -noupdate /multicycle_tb/reset
#add wave -noupdate /multicycle_tb/clock
add wave -noupdate /multicycle_tb/reset
add wave -noupdate /multicycle_tb/clock
#add wave -noupdate -divider {Hex Display}
#add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/HEX_display/in0
#add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/HEX_display/in1
#add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/HEX_display/in2
#add wave -noupdate -radix hexadecimal /multicycle_tb/DUT/HEX_display/in3
#add wave -noupdate -divider {multicycle.v inputs}
#add wave -noupdate /multicycle_tb/KEY
#add wave -noupdate /multicycle_tb/SW
#add wave -noupdate -divider {multicycle.v outputs}
#add wave -noupdate /multicycle_tb/LEDG
#add wave -noupdate /multicycle_tb/LEDR
#add wave -noupdate /multicycle_tb/HEX0
#add wave -noupdate /multicycle_tb/HEX1
#add wave -noupdate /multicycle_tb/HEX2
#add wave -noupdate /multicycle_tb/HEX3
#add wave -noupdate /multicycle_tb/HEX4
#add wave -noupdate /multicycle_tb/HEX5
#add wave -noupdate /multicycle_tb/HEX6
#add wave -noupdate /multicycle_tb/HEX7
#add wave -noupdate -divider {Memory Output}
#add wave -noupdate /multicycle_tb/DUT/MEMwire
#add wave -noupdate /multicycle_tb/DUT/INSTRwire
#add wave -noupdate /multicycle_tb/DUT/InstrCount
#add wave -noupdate /multicycle_tb/DUT/IncCount

add wave -noupdate -divider {Controller}
add wave -noupdate /multicycle_tb/DUT/Control/*
add wave -noupdate -divider {RF}
add wave -noupdate  -radix hexadecimal /multicycle_tb/DUT/RF_block/k0
add wave -noupdate  -radix hexadecimal /multicycle_tb/DUT/RF_block/k1
add wave -noupdate  -radix hexadecimal /multicycle_tb/DUT/RF_block/k2
add wave -noupdate  -radix hexadecimal /multicycle_tb/DUT/RF_block/k3
add wave -noupdate -divider {ALU}
add wave -noupdate /multicycle_tb/DUT/ALU/*
add wave -noupdate -divider {WB}
add wave -noupdate /multicycle_tb/DUT/WB_reg/data
add wave -noupdate /multicycle_tb/DUT/WB_reg/q
add wave -noupdate /multicycle_tb/DUT/WB_reg/enable

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2500000 ps} 0}
configure wave -namecolwidth 227
configure wave -valuecolwidth 57
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1000 ns}
