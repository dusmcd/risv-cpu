import cpu_tb_pkg::*;

module scoreboard(cpu_bfm bfm);
  CPUReferenceModel ref_model;

  initial ref_model = new();

  always @(posedge bfm.clk) begin : scoreboard
    if (bfm.valid_WB && !$isunknown(bfm.instruction_WB)) begin
      // check reference model against DUT 
      ref_model.decode_and_execute(bfm.instruction_WB, bfm.instr, bfm.expected);
      if (bfm.writedata_WB != bfm.expected) begin
        $error("destination register incorrect. expected=%h got=%h for instruction=%h", bfm.expected, bfm.writedata_WB, bfm.instruction_WB);
      end
    end
  end : scoreboard

endmodule
