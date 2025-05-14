if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work

vlog -work work ../HDL/BullsCows.sv
vlog -work work ../HDL/dspl_drv_NexysA7.sv
vlog -work work ../HDL/edge_detector_s.sv
vlog -work work ../HDL/pontuacao.sv
vlog -work work ../HDL/Top_module.sv

vlog -work work tb_final.sv
vsim -voptargs=+acc work.tb_final

quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1

do wave.do
run -all

