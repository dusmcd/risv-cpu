import cpu_tb_pkg::*;

module simtop;
  bit clk;
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic [3:0] KEY;
	logic [17:0] SW;
  instr_t instr;

	top dut
	(
		//////////// CLOCK //////////
		.CLOCK_50(clk),
		.CLOCK2_50(),
	    .CLOCK3_50(),

		//////////// LED //////////
		.LEDG(),
		.LEDR(),

		//////////// KEY //////////
		.KEY(KEY),

		//////////// SW //////////
		.SW(SW),

		//////////// SEG7 //////////
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.HEX6(HEX6),
		.HEX7(HEX7)
	);


  // driving the clock in simulation
  always begin
    #5 clk = ~clk;
  end

  // ensure that all instructions have been executed
  covergroup cg @(posedge clk);
    coverpoint instr {
      bins ADD = {ADD};
      bins SUB = {SUB};
      bins AND = {AND};
      bins OR = {OR};
      bins XOR = {XOR};
      bins SLL = {SLL};
      bins SRA = {SRA};
      bins SRL = {SRL};
      bins SLT = {SLT};
      bins SLTU = {SLTU};
      bins MUL = {MUL};
      bins MULH = {MULH};
      bins MULHU = {MULHU};
      bins CSRRW = {CSRRW};
      bins ADDI = {ADDI};
      bins ANDI = {ANDI};
      bins ORI = {ORI};
      bins XORI = {XORI};
      bins SLLI = {SLLI};
      bins SRAI = {SRAI};
      bins SRLI = {SRLI};
      bins LUI = {LUI};
    }
  endgroup

  CPUInstruction cpu_instr;
  CPUReferenceModel ref_model;
  instr_t current_instr;
  logic [31:0] expected;
  logic [31:0] instruction_WB;
  logic [31:0] instruction_EX;
  bit valid_WB;
  logic stall_EX;
  bit rst; // active low reset
  int num_instructions;


  cg cg_inst;

  // pulse reset
  initial begin
    rst = 1'b0;
    #10;
    rst = 1'b1;
  end
  initial begin : tester
    instr = NOOP;
    num_instructions = 10;
    ref_model = new();
    cpu_instr = new();
    cg_inst = new();
    cpu_instr.create_instr_file(num_instructions);
    #1;
    // call $readmemh 

    // wait for reset
    wait(rst == 1'b1);
    repeat(num_instructions) @(negedge clk);
    $display("Coverage = %0.2f %%", cg_inst.get_inst_coverage());
    $finish;
  end : tester

  
  always_ff @(posedge clk) begin
    if (~rst)
      valid_WB <= 1'b0;
    else begin
      valid_WB <= ~stall_EX;
      instruction_WB <= instruction_EX;
    end
  end

  /*
    TODO:
     (1) assign instruction_EX to corresponding DUT signal
     (2) assign stall_EX to corresponding DUT signal
     (3) rst will be replaced with KEY signal
     (4) pulse reset
  */
  
  /*
  always @(posedge clk) begin : scoreboard
    if (valid_WB && !$isunknown(instruction_WB)) begin
      // check reference model against DUT 
      ref_model.decode_and_execute(instruction_WB, current_instr, expected);
    end
  end : scoreboard
  */

endmodule
