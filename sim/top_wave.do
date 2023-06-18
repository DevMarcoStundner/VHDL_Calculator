onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_top/clk_i
add wave -noupdate -format Logic /tb_top/reset_i
add wave -noupdate -format Logic /tb_top/sw_i
add wave -noupdate -format Logic /tb_top/pb_i
add wave -noupdate -format Logic /tb_top/ss_o
add wave -noupdate -format Logic /tb_top/ss_sel_o
add wave -noupdate -format Logic /tb_top/led_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left