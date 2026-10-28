`timescale 1ns / 1ps

module datapath(
    input clk, reset,
    input memtoreg,
    input pcsrc, alusrc,
    input regdst, regwrite,
    input jump,
    input [2:0] alucontrol,
    input [31:0] readdata,
    input [31:0] instr,
    output zero,
    output [31:0] aluout, writedata, pc_out
);

    // Wires
    wire [31:0] pc, pc_next, pc_plus4, imm_ext, imm_shifted, pc_branch;
    wire [31:0] pc_jump, result;
    wire [4:0]  writereg;
    wire [31:0] regdata1, regdata2;
    wire [31:0] alu_srcB;
    wire branch_taken;
    wire [31:0] pc_after_branch;
    
    assign pc_out = pc; //PC out

    assign writedata = regdata2;

    //----------------------
    // PROGRAM COUNTER
    //----------------------
    program_counter pc_reg(
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );

    //----------------------
    // PC + 4
    //----------------------
    adder pc_adder(
        .a(pc),
        .b(32'd4),
        .sum(pc_plus4)
    );

    //----------------------
    // SIGN EXTEND
    //----------------------
    sign_extend sign_ext(
        .imm16(instr[15:0]),
        .imm32(imm_ext)
    );

    //----------------------
    // SHIFT LEFT 2
    //----------------------
    left_shift_2 shift(
        .in(imm_ext),
        .out(imm_shifted)
    );

    //----------------------
    // BRANCH ADDER
    //----------------------
    adder branch_adder(
        .a(imm_shifted),
        .b(pc_plus4),
        .sum(pc_branch)
    );

    //----------------------
    // JUMP ADDRESS
    //----------------------
    assign pc_jump = {pc_plus4[31:28], instr[25:0], 2'b00};

    //----------------------
    // REGISTER FILE
    //----------------------
    assign writereg = regdst ? instr[15:11] : instr[20:16];

    register_file reg_file(
        .clk(clk),
        .we(regwrite & ~reset),  // protect during reset
        .ra1(instr[25:21]),
        .ra2(instr[20:16]),
        .wa(writereg),
        .wd(result),
        .rd1(regdata1),
        .rd2(regdata2)
    );

    //----------------------
    // ALU SOURCE MUX
    //----------------------
    mux2x1 alusrc_mux (
        .in0(regdata2),
        .in1(imm_ext),
        .sel(alusrc & ~reset),
        .out(alu_srcB)
    );

    //----------------------
    // ALU
    //----------------------
    alu ALU(
        .a(regdata1),
        .b(alu_srcB),
        .ctr(alucontrol),
        .result(aluout),
        .zero(zero)
    );

    //----------------------
    // WRITEBACK MUX
    //----------------------
    mux2x1 memtoreg_mux (
        .in0(aluout),
        .in1(readdata),
        .sel(memtoreg & ~reset),
        .out(result)
    );

    //----------------------
    // NEXT PC LOGIC (Hardened)
    //----------------------
    assign branch_taken = (reset) ? 1'b0 : pcsrc;

    mux2x1 branch_mux (
        .in0(pc_plus4),
        .in1(pc_branch),
        .sel(branch_taken),
        .out(pc_after_branch)
    );

    mux2x1 jump_mux (
        .in0(pc_after_branch),
        .in1(pc_jump),
        .sel(jump & ~reset),
        .out(pc_next)
    );

endmodule
