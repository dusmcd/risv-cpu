import cpu_tb_pkg::*;

module simtop;

  cpu_bfm bfm();
	top #(.instruction_file("tb_instructions.txt")) dut
	(
		//////////// CLOCK //////////
		.CLOCK_50(bfm.clk),
		.CLOCK2_50(),
	    .CLOCK3_50(),

		//////////// LED //////////
		.LEDG(),
		.LEDR(),

		//////////// KEY //////////
		.KEY(bfm.KEY),

		//////////// SW //////////
		.SW(bfm.SW),

		//////////// SEG7 //////////
		.HEX0(bfm.HEX0),
		.HEX1(bfm.HEX1),
		.HEX2(bfm.HEX2),
		.HEX3(bfm.HEX3),
		.HEX4(bfm.HEX4),
		.HEX5(bfm.HEX5),
		.HEX6(bfm.HEX6),
		.HEX7(bfm.HEX7)
	);
 
  tester tester_i(.bfm(bfm), .dut_instruction_EX(dut.cpu.instruction_EX), .dut_writedata_WB(dut.cpu.writedata_WB));
  scoreboard scoreboard_i(.bfm(bfm));
  coverage coverage_i(.bfm(bfm));

endmodule
