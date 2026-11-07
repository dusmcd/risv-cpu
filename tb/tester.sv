class tester;
  virtual cpu_bfm bfm;
 
  function new(virtual cpu_bfm b);
    this.bfm = b;
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
    pipeline();
    bfm.reset_cpu();
    repeat(300) @(negedge bfm.clk);
    bfm.done = 1'b1;
  endtask


endclass
