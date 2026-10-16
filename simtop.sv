/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clk;
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic [3:0] KEY;
	logic [17:0] SW;
  logic [31:0] instruction;
  logic[6:0] opcode;
  logic[4:0] rd, rs1, rs2;
  logic[2:0] funct3;
  logic [6:0] funct7;
  logic[11:0] csr, imm;
  logic [19:0] imm_u;
  logic[4:0] shamt;
  logic alusrc;
  logic regwrite;
  logic[1:0] regsel;
  logic[3:0] aluop;
  logic gpio_we;
  int errors = 0;


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


	// pulse reset (active low)
	initial begin
		KEY <= 4'he;
		#10;
		KEY <= 4'hf;
	end

  initial begin
    #1;
    $readmemh("testbench.txt", dut.cpu.instruction_mem);
  end

 	
	// drive clock
	always begin
		clk <= 1'b0; #5;
		clk <= 1'b1; #5;
	end

  always @(negedge clk) begin
    if (dut.cpu.PC_FETCH <= 12'd28) begin
      $display("instruction_EX: %h", dut.cpu.instruction_EX);
      for (int i = 0; i < 32; i++)
        $display("x%d: %h", i, dut.cpu.regfile.mem[i]);    
    end
  end
	
	// assign simulated switch values
	assign SW = 18'd12345;

endmodule

