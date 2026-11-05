import cpu_tb_pkg::*;

module simtop;
  bit clk;
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic [3:0] KEY;
	logic [17:0] SW;
  instr_t instr;

	top #(.instruction_file("tb_instructions.txt")) dut
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

  CPUReferenceModel ref_model;
  logic [31:0] expected;
  logic [31:0] instruction_WB;
  logic [31:0] instruction_EX;
  logic [31:0] writedata_WB;
  bit valid_WB;
  bit rst; // active low reset
  cg cg_inst;

  // pulse reset
  initial begin : reset
    KEY = 4'b1110;
    #10;
    KEY = 4'b1111;
  end : reset

  assign rst = KEY[0];
  initial begin : tester
    ref_model = new();
    cg_inst = new();
    // call $readmemh 

    // wait for reset
    wait(rst == 1'b1);
    repeat(300) @(negedge clk);
    $display("Coverage = %0.2f %%", cg_inst.get_inst_coverage());
    $finish;
  end : tester

  
  always_ff @(posedge clk) begin
    if (~rst)
      valid_WB <= 1'b0;
    else begin
      valid_WB <= 1'b1;
      instruction_WB <= instruction_EX;
    end
  end

  assign instruction_EX = dut.cpu.instruction_EX;
  assign writedata_WB = dut.cpu.writedata_WB;
  
  always @(posedge clk) begin : scoreboard
    if (valid_WB && !$isunknown(instruction_WB)) begin
      // check reference model against DUT 
      ref_model.decode_and_execute(instruction_WB, instr, expected);
      if (writedata_WB != expected) begin
        $error("destination register incorrect. expected=%h got=%h for instruction=%h", expected, writedata_WB, instruction_WB);
      end
    end
  end : scoreboard

endmodule
