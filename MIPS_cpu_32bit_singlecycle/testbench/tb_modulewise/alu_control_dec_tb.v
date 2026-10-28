`timescale 1ns / 1ps

module alu_control_dec_tb();

    reg [5:0] funct;
    reg [1:0] aluop;
    wire [2:0] alucontrol;

    alu_control_dec uut (
        .funct(funct),
        .aluop(aluop),
        .alucontrol(alucontrol)
    );

    initial begin
        $display("==== ALU CONTROL UNIT TEST START ====");
        $monitor("ALUOp=%b | Funct=%b | ALUControl=%b", aluop, funct, alucontrol);

        // LW/SW/ADDI (should ADD)
        aluop = 2'b00; funct = 6'bxxxxxx; #10;
        // BEQ (should SUB)
        aluop = 2'b01; funct = 6'bxxxxxx; #10;

        // R-type: Test each funct
        aluop = 2'b10;

        funct = 6'b100000; #10; // ADD
        funct = 6'b100010; #10; // SUB
        funct = 6'b100100; #10; // AND
        funct = 6'b100101; #10; // OR
        funct = 6'b101010; #10; // SLT
        funct = 6'b000000; #10; // Undefined

        $display("==== ALU CONTROL UNIT TEST DONE ====");
        $finish;
    end

endmodule
