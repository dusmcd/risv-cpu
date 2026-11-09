
module simtop;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import cpu_test_pkg::*;
  cpu_bfm bfm(
		.dut_instruction_EX(dut.cpu.instruction_EX),
    .dut_writedata_WB(dut.cpu.writedata_WB)
	);
	top #(.read_instructions(1'b0)) dut
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

 
  initial begin
    uvm_config_db #(virtual interface cpu_bfm)::set(null, "*", "bfm", bfm);
    run_test();
  end

  initial begin
    forever begin
      wait(bfm.load_instr_request);
      $readmemh("tb_instructions.txt", dut.cpu.instruction_mem);
      bfm.load_instr_done = 1;

      wait(bfm.load_instr_request == 0);
    end
  end

endmodule
