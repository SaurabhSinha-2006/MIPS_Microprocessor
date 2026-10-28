`timescale 1ns / 1ps

module datapath_tb;

    // Inputs
    reg clk;
    reg reset;
    reg memtoreg;
    reg pcsrc;
    reg alusrc;
    reg regdst;
    reg regwrite;
    reg jump;
    reg [2:0] alucontrol;
    reg [31:0] readdata;
    reg [31:0] instr;

    // Outputs
    wire zero;
    wire [31:0] aluout;
    wire [31:0] writedata;

    // DUT
    datapath uut (
        .clk(clk),
        .reset(reset),
        .memtoreg(memtoreg),
        .pcsrc(pcsrc),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .alucontrol(alucontrol),
        .readdata(readdata),
        .instr(instr),
        .zero(zero),
        .aluout(aluout),
        .writedata(writedata)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        memtoreg = 0;
        pcsrc = 0;
        alusrc = 0;
        regdst = 0;
        regwrite = 0;
        jump = 0;
        alucontrol = 3'b010;
        instr = 32'b0;
        readdata = 0;

        $display("\n===== DATAPATH SIMULATION START =====\n");
        $monitor("T=%0t | clk=%b | reset=%b | instr=%h | aluout=%h | writedata=%h | zero=%b",
                  $time, clk, reset, instr, aluout, writedata, zero);

        #10 reset = 0;

        // Test 1: ADDI
        instr = 32'b001000_00000_01000_0000000000001010; // addi
        alusrc   = 1;
        regwrite = 1;
        alucontrol = 3'b010; // ADD
        #20;

        // Test 2: R-type ADD
        instr = 32'b000000_01000_01000_01001_00000_100000; // add
        alusrc = 0;
        regdst = 1;
        #20;

        // Test 3: Branch-like operation
        pcsrc = 1;
        alucontrol = 3'b110; // SUB for zero check
        #20;

        $display("\n===== SIMULATION COMPLETE =====");
        $finish;
    end

endmodule
