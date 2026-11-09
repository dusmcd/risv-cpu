class raw_test extends uvm_test;
  `uvm_component_utils(raw_test);
  virtual cpu_bfm bfm;

  function new (string name, uvm_component parent);
    super.new(name, parent);
    if (!uvm_config_db #(virtual cpu_bfm)::get(null, "*", "bfm", bfm))
      $fatal("Failed to get BFM");
  endfunction

  task run_phase(uvm_phase phase);
    raw_tester raw_tester_i;
    scoreboard scoreboard_i;
    coverage coverage_i;

    phase.raise_objection(this);

    raw_tester_i = new(bfm);
    coverage_i = new(bfm);
    scoreboard_i = new(bfm);

    fork
      coverage_i.execute();
      scoreboard_i.execute();
    join_none

    raw_tester_i.execute(100);
    phase.drop_objection(this);
  endtask

endclass
