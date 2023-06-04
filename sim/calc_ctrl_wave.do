onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_calc_ctrl/clk_i
add wave -noupdate -format Logic /tb_calc_ctrl/reset_i
add wave -noupdate -format Logic /tb_calc_ctrl/dig0_o
add wave -noupdate -format Logic /tb_calc_ctrl/dig1_o
add wave -noupdate -format Logic /tb_calc_ctrl/dig2_o
add wave -noupdate -format Logic /tb_calc_ctrl/dig3_o
add wave -noupdate -format Logic /tb_calc_ctrl/led_o
add wave -noupdate -format Logic /tb_calc_ctrl/swsync_i
add wave -noupdate -format Logic /tb_calc_ctrl/pbsync_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left