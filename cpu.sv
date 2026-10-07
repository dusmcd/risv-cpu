module cpu(input logic clk, logic rst);
  logic[31:0] instruction_mem [4095:0];
  logic[31:0] instruction_EX;
  initial $readmemh("hexcode.txt", instruction_mem);

  logic[11:0] PC_FETCH;
  logic [4:0] regdest_WB;

  always_ff @(posedge clk) begin
    if(~rst) begin
      instruction_EX <= 32'b0;
      PC_FETCH <= 12'b0;
    end

    else begin
      instruction_EX <= instruction_mem[PC_FETCH];
      PC_FETCH <= PC_FETCH + 12'b1;
    end
  end
  
  // instantiate decoder and control unit
  // instantiate regfile and alu

  // pipeline registers
  always_ff @(posedge clk) begin
    
  end


endmodule
