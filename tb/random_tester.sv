class random_tester;
  virtual cpu_bfm bfm;
  CPUInstruction cpu_instr;
 
  function new(virtual cpu_bfm b);
    this.bfm = b;
    cpu_instr = new();
  endfunction

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

  
  task execute();
    cpu_instr.create_instr_file(bfm.num_instructions);
    bfm.load_instructions();
    pipeline();
    bfm.reset_cpu();
    repeat(300) @(negedge bfm.clk);
    bfm.done = 1'b1;
  endtask


endclass
