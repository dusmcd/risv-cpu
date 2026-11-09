class scoreboard;
  CPUReferenceModel ref_model;
  virtual cpu_bfm bfm;

  function new(virtual cpu_bfm bfm);
    this.bfm = bfm;
    this.ref_model = new();
  endfunction

  task execute();
    int clock_num = 0;
    forever begin 
      @(posedge bfm.clk)

      if (bfm.valid_WB && !$isunknown(bfm.instruction_WB)) begin
        // check reference model against DUT 
        ref_model.decode_and_execute(bfm.instruction_WB, bfm.instr, bfm.expected);
        if (bfm.writedata_WB != bfm.expected) begin
          $error("destination register incorrect. expected=%h got=%h for instruction=%h", bfm.expected, bfm.writedata_WB, bfm.instruction_WB);
        end
      end
    end 
  endtask

endclass
