#!/usr/bin/bash

vlog -sv ../*.sv cpu_tb_pkg.sv generate_instructions.sv cpu_bfm.sv tester.sv scoreboard.sv coverage.sv simtop.sv

vsim -c work.generate_instructions -do "run -all; quit -f"
vsim -c work.simtop -do "run -all; quit -f"
