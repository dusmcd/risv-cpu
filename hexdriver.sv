module hexdriver (input [3:0] val, output logic [6:0] HEX);

  always_comb
    case(val)
       4'd0: HEX = 7'b1000000;
       4'd1: HEX = 7'b1111001;
       4'd2: HEX = 7'b0100100;
       4'd3: HEX = 7'b0110000;
       4'd4: HEX = 7'b0011001;
       4'd5: HEX = 7'b0010010;
       4'd6: HEX = 7'b0000010;
       4'd7: HEX = 7'b1111000;
       4'd8: HEX = 7'b0000000;
       4'd9: HEX = 7'b0010000;
       4'hA: HEX = 7'b0001000;
       4'hB: HEX = 7'b0000000; // looks same as 8
       4'hC: HEX = 7'b1000110;
       4'hD: HEX = 7'b1000000; // looks same as 0
       4'hE: HEX = 7'b0000110;
       default: HEX = 7'b0001110;
    endcase

endmodule
