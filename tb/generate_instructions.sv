import cpu_tb_pkg::CPUInstruction;

module generate_instructions;

  int num_instructions;
  CPUInstruction cpu_instr;

  initial begin
    num_instructions = 100;
    cpu_instr = new();
    cpu_instr.create_instr_file(num_instructions);
    $finish;
  end

endmodule
