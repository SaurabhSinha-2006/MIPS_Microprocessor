`timescale 1ns / 1ps

module controller(
    input [5:0] op, funct,
    input zero,
    output memtoreg, memwrite,
    output pcsrc, alusrc,
    output regdst, regwrite,
    output jump,
    output [2:0] alucontrol
);

    wire [1:0] aluop;
    wire branch;

    main_control_dec md(
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

    alu_control_dec ad(
        .funct(funct),
        .aluop(aluop),
        .alucontrol(alucontrol)
    );

    assign pcsrc = branch & zero;

endmodule
