module tester(cpu_bfm bfm, input logic [31:0] dut_instruction_EX, input logic [31:0] dut_writedata_WB);

  always_ff @(posedge bfm.clk) begin
    if (~bfm.KEY[0])
      bfm.valid_WB <= 1'b0;
    else begin
      bfm.valid_WB <= 1'b1;
      bfm.instruction_WB <= bfm.instruction_EX;
    end
  end

  assign bfm.instruction_EX = dut_instruction_EX;
  assign bfm.writedata_WB = dut_writedata_WB;

  initial begin
    bfm.reset_cpu();
    repeat(300) @(negedge bfm.clk);
    bfm.done = 1'b1;
  end


endmodule
