`timescale 1ns / 1ps

module cpu_top (
    input clk,
    input reset
);

    // Internal wires
    wire [31:0] pc;
    wire [31:0] instr;
    wire [31:0] aluout;
    wire [31:0] writedata;
    wire [31:0] readdata;
    wire zero;

    wire memtoreg, memwrite;
    wire pcsrc, alusrc;
    wire regdst, regwrite;
    wire jump;
    wire [2:0] alucontrol;

    // ====================================================
    // Instruction Memory
    // ====================================================
    instruction_memory imem (
        .addr(pc),
        .instr(instr)
    );

    // ====================================================
    // Controller
    // ====================================================
    controller ctrl (
        .op(instr[31:26]),
        .funct(instr[5:0]),
        .zero(zero),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .pcsrc(pcsrc),
        .alusrc(alusrc),
        .regdst(regdst),
        .regwrite(regwrite),
        .jump(jump),
        .alucontrol(alucontrol)
    );

    // ====================================================
    // Datapath
    // ====================================================
    datapath dp (
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
        .writedata(writedata),
        .pc_out(pc)
    );

    // ====================================================
    // Data Memory
    // ====================================================
    data_memory dmem (
        .clk(clk),
        .we(memwrite),
        .addr(aluout),
        .wd(writedata),
        .rd(readdata)
    );

endmodule
