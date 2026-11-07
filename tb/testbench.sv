class testbench;
  virtual cpu_bfm bfm;

  tester tester_i;
  coverage coverage_i;
  scoreboard scoreboard_i;

  function new(virtual cpu_bfm b);
    this.bfm = b;
  endfunction

  task execute();
    tester_i = new(bfm);
    coverage_i = new(bfm);
    scoreboard_i = new(bfm);

    fork
      tester_i.execute();
      coverage_i.execute();
      scoreboard_i.execute();
    join_none
  endtask

endclass
