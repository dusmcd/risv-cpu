module control_unit(
  input logic[6:0] opcode,
  input logic[2:0] funct3,
  input logic[6:0] funct7,
  input logic[11:0] csr,
  output logic alusrc,
  output logic regwrite,
  output logic[1:0] regsel,
  output logic[3:0] aluop,
  output logic gpio_we
  );

  always_comb begin
    // default values
    alusrc = 1'b0;
    regwrite = 1'b0;
    regsel = 2'b10;
    aluop = 4'b0000;
    gpio_we = 1'b0;
    if (opcode == 7'b0110011) begin
      // this is an R-type
      regwrite = 1'b1;
      gpio_we = 1'b0;
      regsel = 2'b10;
      alusrc = 1'b0;
      // check funct3 and funct7 for aluop
      if (funct3 == 3'b000 && funct7 == 7'b0) aluop = 4'b0011; // add
      else if (funct3 == 3'b000 && funct7 == 7'b0100000) aluop = 4'b0100; // sub
      else if (funct3 == 3'b111 && funct7 == 7'b0) aluop = 4'b0000; // and
      else if (funct3 == 3'b110 && funct7 == 7'b0) aluop = 4'b0001; // or
      else if (funct3 == 3'b100 && funct7 == 7'b0) aluop = 4'b0010; // xor
      else if (funct3 == 3'b001 && funct7 == 7'b0) aluop = 4'b1000; // sll
      else if (funct3 == 3'b101 && funct7 == 7'b0100000) aluop = 4'b1010; // sra
      else if (funct3 == 3'b101 && funct7 == 7'b0) aluop = 4'b1001; // srl
      else if (funct3 == 3'b010 && funct7 == 7'b0) aluop = 4'b1100; // slt
      else if (funct3 == 3'b011 && funct7 == 7'b0) aluop = 4'b1101; // sltu
      else if (funct3 == 3'b000 && funct7 == 7'b0000001) aluop = 4'b0101; // mul
      else if (funct3 == 3'b001 && funct7 == 7'b0000001) aluop = 4'b0110; // mulh
      else if (funct3 == 3'b011 && funct7 == 7'b0000001) aluop = 4'b0111; // mulhu
    end

    else if (opcode == 7'b0010011) begin
      // this is an I-type
      regwrite = 1'b1;
      gpio_we = 1'b0;
      regsel = 2'b10;
      alusrc = 1'b1;
      // check funct3 for specific instruction
      case(funct3)
        3'b000: aluop = 4'b0011; // addi
        3'b111: aluop = 4'b0000; // andi
        3'b110: aluop = 4'b0001; // ori
        3'b100: aluop = 4'b0010; // xori
        3'b001: aluop = 4'b1000; // slli
        3'b101: begin
          if (funct7 == 7'b0100000) aluop = 4'b1010; // srai
          else if (funct7 == 7'b0) aluop = 4'b1001; // srli
        end
      endcase

    end

    else if (opcode == 7'b1110011) begin
      // this is the csrrw instruction used for GPIO
      regwrite = 1'b1;
      alusrc = 1'bX; // not used in this instruction
      aluop = 4'bXXXX;

      // need to switch on the address in immediate field
      case(csr)
        12'hF00: begin
          // write switches to rd
          regsel = 2'b00;
          gpio_we = 1'b0;
        end
        12'hF02:
          // write value of rs1 into HEX displays
          gpio_we = 1'b1;
      endcase
    end

    else if (opcode == 7'b0110111) begin
      // this is a U-type
      gpio_we = 1'b0;
      regsel = 2'b01;
      regwrite = 1'b1;
      alusrc = 1'bX; // not used in this instruction
      aluop = 4'bXXXX;
    end

    else begin
      gpio_we = 1'b0;
      regwrite = 1'b0;
    end
  end

endmodule
