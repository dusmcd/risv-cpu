
module simtop;

  import cpu_test_pkg::*;
  cpu_bfm bfm(
		.dut_instruction_EX(dut.cpu.instruction_EX),
		.dut_writedata_WB(dut.cpu.writedata_WB),
		.dut_instruction_mem(dut.cpu.instruction_mem)
	);
	top dut
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

	assign bfm.instruction_mem = dut.cpu.instruction_mem;

  testbench testbench_i;
 
  initial begin
    testbench_i = new(bfm);
    testbench_i.execute();
  end

endmodule
