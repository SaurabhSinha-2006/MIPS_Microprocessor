`timescale 1ns / 1ps

module main_control_dec_tb();

    reg [5:0] op;
    wire memtoreg, memwrite, branch, regdst, regwrite, alusrc, jump;
    wire [1:0] aluop;

    // Instantiate Unit Under Test (UUT)
    main_control_dec uut (
        .op(op),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .branch(branch),
        .regdst(regdst),
        .regwrite(regwrite),
        .alusrc(alusrc),
        .aluop(aluop),
        .jump(jump)
    );

    initial begin
        $display("==== MAIN CONTROL UNIT TEST START ====");
        $monitor("op=%b | RegWrite=%b RegDst=%b ALUSrc=%b MemtoReg=%b MemWrite=%b Branch=%b Jump=%b ALUOp=%b",
                 op, regwrite, regdst, alusrc, memtoreg, memwrite, branch, jump, aluop);

        // R-type
        op = 6'b000000; #10;
        // LW
        op = 6'b100011; #10;
        // SW
        op = 6'b101011; #10;
        // BEQ
        op = 6'b000100; #10;
        // ADDI
        op = 6'b001000; #10;
        // JUMP
        op = 6'b000010; #10;

        $display("==== MAIN CONTROL UNIT TEST DONE ====");
        $finish;
    end

endmodule
