// alu.v - 8-bit ALU for 8-bit custom MIPS
// ALU operations selected by 3-bit ALUfn
`timescale 1ns/1ps
module alu (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [2:0] alufn,
    output reg  [7:0] y,
    output wire       zero
);
    always @(*) begin
        case (alufn)
            3'b000: y = a + b;        // add
            3'b001: y = a - b;        // sub
            3'b010: y = a & b;        // and
            3'b011: y = a | b;        // or
            // other ALUfn values can map to address calc (add)
            3'b100: y = a + b;        // add (e.g., addi)
            3'b101: y = a + b;        // address calc (lw)
            3'b110: y = a + b;        // address calc (sw)
            3'b111: y = (a == b) ? 8'b0 : 8'b1; // compare for beq (zero flag used)
            default: y = 8'b0;
        endcase
    end

    assign zero = (a == b);
endmodule
