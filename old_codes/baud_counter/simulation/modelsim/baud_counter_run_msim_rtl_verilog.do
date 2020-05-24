transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Verilog/old_codes/baud_counter {D:/Verilog/old_codes/baud_counter/counter.v}
vlog -vlog01compat -work work +incdir+D:/Verilog/aESSENTIALS {D:/Verilog/aESSENTIALS/REGISTER.v}
vlog -vlog01compat -work work +incdir+D:/Verilog/old_codes/baud_counter {D:/Verilog/old_codes/baud_counter/baud_counter.v}

vlog -vlog01compat -work work +incdir+D:/Verilog/old_codes/baud_counter {D:/Verilog/old_codes/baud_counter/bc_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  bc_tb

add wave *
view structure
view signals
run -all
