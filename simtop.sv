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
  logic[4:0] shamt;
  logic alusrc
  logic regwrite;
  logic[1:0] regsel;
  logic[3:0] aluop;
  logic gpio_we;


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


  instr_decode instr_decode(.instruction(instruction),
    .opcode(opcode),
    .rd(rd),
    .rs1(rs1),
    .rs2(rs2),
    .funct3(funct3),
    .funct7(funct7),
    .csr(csr),
    .imm(imm),
    .shamt(shamt));

  control_unit control_unit(
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .csr(csr),
    .alusrc(aluscr),
    .regwrite(regwrite),
    .regsel(regsel),
    .aluop(aluop),
    .gpio_we(gpio_we)
  );

	// pulse reset (active low)
	initial begin
		KEY <= 4'he;
		#10;
		KEY <= 4'hf;
	end

  initial begin
    // test control signals 
    
    /*
    * testing r-type signals
    */
    instruction = 32'b0110011;
    #10;


    /*
    * testing i-type signals
    */
    instruction = 32'b0010011;
    #10;

    /*
    * testing csr signals
    */
    instruction = 32'b1110011;
    #10;

    /*
    * testing u-type signals
    */
    instruction = 32'b0110111;
    #10;

  end
	
	// drive clock
	always begin
		clk <= 1'b0; #5;
		clk <= 1'b1; #5;
	end
	
	// assign simulated switch values
	assign SW = 18'd12345;

endmodule

