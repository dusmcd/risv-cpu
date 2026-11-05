#!/usr/bin/bash

vlog -sv ../*.sv cpu_tb_pkg.sv simtop.sv
vsim -c work.simtop -do "run -all; quit -f"
