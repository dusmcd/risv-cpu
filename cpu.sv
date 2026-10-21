module cpu(input logic clk, input logic rst, input logic[17:0] io_in, output logic [31:0] io_out);
  logic[31:0] instruction_mem [4095:0];
  logic[31:0] instruction_EX;
  initial $readmemh("hexcode.txt", instruction_mem);

  logic[11:0] PC_FETCH;
  logic [31:0] io_WB;
  logic [4:0] regdest_WB;
  logic [6:0] opcode;
  logic [4:0] rd, rs1, rs2;
  logic [2:0] funct3;
  logic [6:0] funct7;
  logic [11:0] csr, imm;
  logic [19:0] imm_u;
  logic [4:0] shamt;
  logic alusrc_EX;
  logic regwrite_EX;
  logic [1:0] regsel_EX;
  logic [1:0] regsel_WB;
  logic gpio_we;
  logic [3:0] aluop_EX;
  logic [31:0] writedata_EX;
  logic [31:0] writedata_WB;
  logic [4:0] writeaddr_WB;
  logic regwrite_WB;
  logic [31:0] rs1_data, rs2_data;
  logic [31:0] alu_output_EX;
  logic [31:0] alu_output_WB;
  logic [31:0] upper_imm_EX;
  logic [31:0] upper_imm_WB;
  logic [31:0] alu_srcdata_EX;
  logic stall_FETCH;
  logic stall_EX;

  always_ff @(posedge clk) begin
    if(~rst) begin
      instruction_EX <= 32'b0;
      PC_FETCH <= 12'b0;
    end

    else begin
      instruction_EX <= instruction_mem[PC_FETCH];

      // need to add logic to handle branch instructions
      PC_FETCH <= PC_FETCH + 12'b1;
    end
  end
  
  
  // instantiate decoder and control unit
  instr_decode decoder(
    .instruction(instruction_EX),
    .opcode(opcode),
    .rd(rd),
    .rs1(rs1),
    .rs2(rs2),
    .funct3(funct3),
    .funct7(funct7),
    .csr(csr),
    .imm(imm),
    .imm_u(imm_u),
    .shamt(shamt)
  );

  assign upper_imm_EX = {imm_u, 12'b0};

  control_unit control_unit(
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .csr(csr),
    .alusrc(alusrc_EX),
    .stall_EX(stall_EX),
    .regwrite(regwrite_EX),
    .regsel(regsel_EX),
    .aluop(aluop_EX),
    .gpio_we(gpio_we),
    .stall_FETCH(stall_FETCH)
  );


  // instantiate regfile and alu
  regfile regfile(
    .clk(clk),
    .we(regwrite_WB),
    .readaddr1(rs1),
    .readaddr2(rs2),
    .writeaddr(writeaddr_WB),
    .writedata(writedata_WB),
    .readdata1(rs1_data),
    .readdata2(rs2_data)
  );

  logic zero;
  alu alu(
    .A(rs1_data),
    .B(alusrc_EX ? {{20{imm[11]}}, imm} : rs2_data),
    .op(aluop_EX),
    .R(alu_output_EX),
    .zero(zero)
  );

  always_comb begin
    if (regsel_WB == 2'b0) writedata_WB = io_WB;
    else if (regsel_WB == 2'b01) writedata_WB = upper_imm_WB;
    else if (regsel_WB == 2'b10) writedata_WB = alu_output_WB;
    else writedata_WB = 32'b0;
  end

  // pipeline registers
  always_ff @(posedge clk) begin
    // register write address and write enable
    writeaddr_WB <= rd;
    regwrite_WB <= regwrite_EX;

    // ALU result, write to register
    alu_output_WB <= alu_output_EX;

    // register selection
    regsel_WB <= regsel_EX;

    // for lui instruction, write to register
    upper_imm_WB <= upper_imm_EX;

    // for writing switches to register
    io_WB <= {14'b0, io_in};

    // delay the stall signal so that the next instruction will be a no op
    stall_EX <= stall_FETCH;

    if (gpio_we) io_out <= rs1_data;
  end

endmodule
