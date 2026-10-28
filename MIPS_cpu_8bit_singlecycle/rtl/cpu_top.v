// cpu_top.v - fixed and matched to your module definitions
`timescale 1ns/1ps

module cpu_top (
    input wire clk,
    input wire rst
);
    // PC and instruction
    wire [7:0] pc, next_pc;
    wire [15:0] instr;

    // Control signals
    wire MemToReg, RegWrite, MemRead, MemWrite;
    wire [2:0] ALUfn;
    wire ALUSrc, isJ, isBEQ;

    // Register file connections
    wire [2:0] ra = instr[10:8];  // source A
    wire [2:0] rb = instr[7:5];   // source B
    wire [2:0] rd = instr[4:2];   // R-type destination

    // Destination register selection (R-type vs I-type)
    wire [2:0] dest_reg = (instr[15:13] == 3'b000) ? rd : ra;

    wire [7:0] rd_a, rd_b;
    wire [7:0] write_data;

    // ALU and memory
    wire [7:0] alu_b, alu_out, mem_out;
    wire zero_flag;

    // Immediate value (zero-extended)
    wire [7:0] imm_ext = {5'b0, instr[2:0]};

    // ===================== Module Instantiations =====================

    // Program Counter
    pc_module pcm (
        .clk(clk),
        .rst(rst),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Instruction Memory
    instr_mem imem (
        .addr(pc),
        .instr(instr)
    );

    // Control Unit
    control ctrl (
        .opcode(instr[15:13]),
        .fn(instr[12:11]),
        .MemToReg(MemToReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUfn(ALUfn),
        .ALUSrc(ALUSrc),
        .isJ(isJ),
        .isBEQ(isBEQ)
    );

    // Register File
    regfile rf (
        .clk(clk),
        .we(RegWrite),
        .ra(ra),
        .rb(rb),
        .wd_addr(dest_reg),   // ✅ corrected: use dest_reg
        .wd(write_data),
        .rd_a(rd_a),
        .rd_b(rd_b)
    );

    // ALU input mux
    assign alu_b = (ALUSrc) ? imm_ext : rd_b;

    // ALU
    alu alu_u (
        .a(rd_a),
        .b(alu_b),
        .alufn(ALUfn),
        .y(alu_out),
        .zero(zero_flag)
    );

    // Data Memory
    data_mem dmem (
        .clk(clk),
        .we(MemWrite),
        .addr(alu_out),
        .wdata(rd_b),
        .rdata(mem_out)
    );

    // Write-Back mux
    assign write_data = (MemToReg) ? mem_out : alu_out;

    // Next PC logic (branch + jump)
    wire [7:0] pc_plus1 = pc + 1;
    wire [7:0] branch_target = pc_plus1 + imm_ext;

    assign next_pc =
        (isJ) ? instr[7:0] :
        (isBEQ && zero_flag) ? branch_target :
        pc_plus1;

endmodule
