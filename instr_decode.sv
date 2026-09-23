module instr_decode( input logic[31:0] instruction,
                    output logic[6:0] opcode,
                    output logic[4:0] rd, rs1, rs2,
                    output logic[2:0] funct3,
                    output logic [6:0] funct7,
                    output logic[11:0] csr, imm,
                    output logic[4:0] shamt);

  // break out instruction fields
  assign opcode = instruction[6:0];
  assign rd = instruction[11:7];
  assign rs1 = instruction[19:15];
  assign rs2 = instruction[24:20];
  assign funct3 = instruction[14:12];
  assign funct7 = instruction[31:25];
  assign csr = instruction[31:20];
  assign imm = instruction[31:20];
  assign shamt = instruction[24:20];

endmodule
