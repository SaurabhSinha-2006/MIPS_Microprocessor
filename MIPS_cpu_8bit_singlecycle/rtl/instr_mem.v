// instr_mem.v - 256 x 16 ROM loaded from imem.hex
`timescale 1ns/1ps
module instr_mem (
    input  wire [7:0] addr,
    output reg  [15:0] instr
);
    reg [15:0] rom [0:255];
    initial begin
        // imem.hex - hex encoded 16-bit words (one per line)
        // Create imem.hex with the assembler.py
        $readmemh("imem.hex", rom);
    end

    always @(*) instr = rom[addr];
endmodule
