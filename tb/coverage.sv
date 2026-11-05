import cpu_tb_pkg::*;

module coverage(cpu_bfm bfm);
  // ensure that all instructions have been executed
  covergroup cg @(posedge bfm.clk);
    coverpoint bfm.instr {
      bins add = {ADD};
      bins sub = {SUB};
      bins and_bin = {AND};
      bins or_bin = {OR};
      bins xor_bin = {XOR};
      bins sll = {SLL};
      bins sra = {SRA};
      bins srl = {SRL};
      bins slt = {SLT};
      bins sltu = {SLTU};
      bins mul = {MUL};
      bins mulh = {MULH};
      bins mulhu = {MULHU};
      bins csrrw = {CSRRW};
      bins addi = {ADDI};
      bins andi = {ANDI};
      bins ori = {ORI};
      bins xori = {XORI};
      bins slli = {SLLI};
      bins srai = {SRAI};
      bins srli = {SRLI};
      bins lui = {LUI};
    }
  endgroup

  cg cg_inst;
  initial begin
    cg_inst = new();
    wait(bfm.done);
    $display("Coverage = %.2f %%", cg_inst.get_inst_coverage());
    $finish;
  end



endmodule
