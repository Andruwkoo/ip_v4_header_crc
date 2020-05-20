onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_top/clk
add wave -noupdate -expand -group dut -radix hexadecimal /tb_top/DUT/acc
add wave -noupdate -expand -group dut -radix hexadecimal /tb_top/DUT/carry
add wave -noupdate -expand -group dut -radix hexadecimal /tb_top/DUT/carry_acc
add wave -noupdate -expand -group dut -radix hexadecimal /tb_top/DUT/carry_z
add wave -noupdate -expand -group dut -radix hexadecimal /tb_top/DUT/clk
add wave -noupdate -expand -group dut -radix hexadecimal /tb_top/DUT/cnt
add wave -noupdate -expand -group dut -radix hexadecimal /tb_top/DUT/crc
add wave -noupdate -expand -group dut -radix hexadecimal /tb_top/DUT/crc_vld
add wave -noupdate -expand -group dut -radix hexadecimal /tb_top/DUT/d_in
add wave -noupdate -expand -group dut -radix hexadecimal /tb_top/DUT/d_in_vld
add wave -noupdate -expand -group dut -radix hexadecimal /tb_top/DUT/reset
add wave -noupdate -expand -group dut -radix hexadecimal /tb_top/DUT/start
add wave -noupdate -expand -group dut -radix hexadecimal /tb_top/DUT/work
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {205922330 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 295
configure wave -valuecolwidth 118
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {1050 ns}
