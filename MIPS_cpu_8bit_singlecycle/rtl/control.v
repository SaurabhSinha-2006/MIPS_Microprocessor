// control.v - control unit according to PDF opcode/fn mapping
// opcode: instr[15:13], fn: instr[12:11]
`timescale 1ns/1ps
module control (
    input  wire [2:0] opcode,
    input  wire [1:0] fn,
    output reg       MemToReg,
    output reg       RegWrite,
    output reg       MemRead,
    output reg       MemWrite,
    output reg [2:0] ALUfn,
    output reg       ALUSrc,
    output reg       isJ,
    output reg       isBEQ
);
    always @(*) begin
        // defaults
        MemToReg = 0;
        RegWrite = 0;
        MemRead  = 0;
        MemWrite = 0;
        ALUfn    = 3'b000;
        ALUSrc   = 0;
        isJ = 0;
        isBEQ = 0;

        case(opcode)
            3'b000: begin // R-type (fn selects add/sub/and/or)
                RegWrite = 1;
                ALUSrc = 0;
                case(fn)
                    2'b00: ALUfn = 3'b000; // add
                    2'b01: ALUfn = 3'b001; // sub
                    2'b10: ALUfn = 3'b010; // and
                    2'b11: ALUfn = 3'b011; // or
                    default: ALUfn = 3'b000;
                endcase
                MemToReg = 0;
            end
            3'b001: begin // addi (I-type)
                RegWrite = 1;
                ALUSrc = 1;
                ALUfn = 3'b100; // treat as add
                MemToReg = 0;
            end
            3'b010: begin // lw (I-type)
                RegWrite = 1;
                ALUSrc = 1;
                ALUfn = 3'b101; // add for address
                MemRead = 1;
                MemToReg = 1;
            end
            3'b011: begin // sw (I-type)
                RegWrite = 0;
                ALUSrc = 1;
                ALUfn = 3'b110; // add for address
                MemWrite = 1;
            end
            3'b100: begin // beq (I-type)
                RegWrite = 0;
                ALUSrc = 0;
                ALUfn = 3'b111; // compare
                isBEQ = 1;
            end
            3'b101: begin // j (J-type)
                isJ = 1;
            end
            default: begin
                // NOP / undefined
            end
        endcase
    end
endmodule
