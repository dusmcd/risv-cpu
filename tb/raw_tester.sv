class raw_tester extends random_tester;
  function new(virtual cpu_bfm bfm);
    super.new(bfm);
  endfunction

  protected virtual task generate_instructions(int num_instructions);
    $display("calling overriden generate_instruction task");
    cpu_instr.create_raw_instr_file(num_instructions);
    bfm.load_instructions();
  endtask

endclass
