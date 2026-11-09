import cpu_tb_pkg::instr_t;

interface cpu_bfm(
  input logic [31:0] dut_instruction_EX,
  input logic [31:0] dut_writedata_WB
);
  bit clk;
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic [3:0] KEY;
	logic [17:0] SW;
  logic [31:0] expected;
  logic [31:0] instruction_WB;
  logic [31:0] instruction_EX;
  logic [31:0] writedata_WB;
  bit valid_WB;
  instr_t instr;
  bit done;
  bit load_instr_request = 0;
  bit load_instr_done = 0;

  // drive clock
  initial begin
    forever begin
      #5 clk = ~clk;
    end
  end

  // drive bfm signals from dut
  assign instruction_EX = dut_instruction_EX;
  assign writedata_WB = dut_writedata_WB;


  task reset_cpu();
    KEY = 4'b1110;
    #10;
    KEY = 4'b1111;
  endtask

  task load_instructions();
    load_instr_done = 0;
    load_instr_request = 1;

    wait(load_instr_done);
    load_instr_request = 0;
  endtask

endinterface
