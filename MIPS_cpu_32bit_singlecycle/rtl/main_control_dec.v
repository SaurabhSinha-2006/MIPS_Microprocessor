`timescale 1ns / 1ps

module main_control_dec(
    input  [5:0] op,
    output memtoreg, memwrite,
    output branch,
    output regdst,
    output regwrite,
    output alusrc,
    output [1:0] aluop,
    output jump
    );

    reg [8:0] controls; 

    assign {regwrite, regdst, alusrc, branch, memwrite, memtoreg, jump, aluop} = controls;

    always @(*) begin
        case (op)
            6'b000000: controls <= 9'b110000010;  // R-type
            6'b100011: controls <= 9'b101001000;  // LW
            6'b101011: controls <= 9'b001010000;  // SW
            6'b000100: controls <= 9'b000100001;  // BEQ
            6'b001000: controls <= 9'b101000000;  // ADDI
            6'b000010: controls <= 9'b000000100;  // JUMP
            default:   controls <= 9'b000000000;  // default safe case
        endcase
    end

endmodule
