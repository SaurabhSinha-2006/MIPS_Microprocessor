`timescale 1ns / 1ps

module alu(input[31:0] a, b,
           input[2:0] ctr,
           output reg [31:0] result,
           output zero);
           
    always @(*)
    begin
        case (ctr)
            3'b010 : result = a + b;
            3'b110 : result = a - b;
            3'b000 : result = a & b;
            3'b001 : result = a | b;
            default : result = 32'd0;
        endcase
    end
    
    assign zero = (result == 32'd0);

          
endmodule
