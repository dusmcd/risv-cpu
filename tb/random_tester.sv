class random_tester;
  virtual cpu_bfm bfm;
  CPUInstruction cpu_instr;
 
  function new(virtual cpu_bfm b);
    this.bfm = b;
    cpu_instr = new();
  endfunction

  protected virtual task generate_instructions(int num_instructions);
    cpu_instr.create_instr_file(num_instructions);
    bfm.load_instructions();
  endtask

  local task pipeline();
    fork
        
     forever begin
      @(posedge bfm.clk)
      if (~bfm.KEY[0])
        bfm.valid_WB <= 1'b0;
      else begin
        bfm.valid_WB <= 1'b1;
        bfm.instruction_WB <= bfm.instruction_EX;
      end
     end

    join_none
  endtask

  
  task execute(int num_instructions);
    generate_instructions(num_instructions);
    pipeline();
    bfm.reset_cpu();
    repeat((31 + num_instructions) * 3) @(negedge bfm.clk);
    bfm.done = 1'b1;
  endtask


endclass
