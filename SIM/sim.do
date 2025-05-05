ATUALIZAR PARA ARQUIVOS DESTE TRABALHO
if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work

vlog -work work ../HDL/


vlog -work work tb_final.sv
vsim -voptargs=+acc work.tb_final

quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1

do wave.do
run 200ns