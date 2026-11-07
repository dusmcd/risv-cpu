#!/usr/bin/bash

vlog -sv ../*.sv cpu_tb_pkg.sv cpu_bfm.sv generate_instructions.sv simtop.sv

vsim -c work.generate_instructions -do "run -all; quit -f"
vsim -c work.simtop -do "run -all; quit -f"
