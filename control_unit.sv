module control_unit(
  input logic[6:0] opcode,
  input logic[2:0] funct3,
  input logic[6:0] funct7,
  input logic[11:0] csr,
  output logic alusrc,
  output logic regwrite,
  output logic[1:0] regsel,
  output logic[3:0] aluop
  output logic gpio_we
  );

  always_comb
    if (opcode == 7'b0110011) begin
      // this is an R-type
      regwrite = 1'b1;
      gpio_we = 1'b0;
      regsel = 2'b10;
      alusrc = 1'b0;
      // check funct3 and funct7 for specific instruction
    end

    else if (opcode == 7'b0010011) begin
      // this is an I-type
      regwrite = 1'b1;
      gpio_we = 1'b10;
      regsel = 2'b10;
      alusrc = 1'b1;
      // check funct3 and funct7 for specific instruction
    end

    else if (opcode == 7'b1110011) begin
      // this is the csrrw instruction used for GPIO
      gpio_we = 1'b1;
      regsel = 2'b00;
      regwrite = 1'b1;
      alusrc = 1'b0; // not used in this instruction
    end

    else if (opcode == 7'b0110111) begin
      // this is a U-type
      gpio_we = 1'b0;
      regsel = 2'b01;
      regwrite = 1'b1;
      alusrc = 1'b0; // not used in this instruction
    end

endmodule
