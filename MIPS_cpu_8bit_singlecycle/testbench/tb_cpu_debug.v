// tb_cpu_debug.v - debug testbench for 8-bit custom MIPS CPU
`timescale 1ns/1ps
module tb_cpu_debug;
    reg clk = 0;
    reg rst = 1;

    // Instantiate CPU top
    cpu_top dut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generator
    always #5 clk = ~clk; // 100 MHz clock (10 ns period)

    integer cycle = 0;

    initial begin
        $display("time | PC | Instr | Opcode | RegWrite | ALUSrc | ALUfn | RA | RB | ALU_B | ALU_OUT | MEM_OUT");
        $display("----------------------------------------------------------------------------------------------");
        #12 rst = 0;   // release reset
    end

    // Observe internal signals
    always @(posedge clk) begin
        cycle = cycle + 1;
        #1; // allow signals to settle

        $display("%8t | %3d | %h | %03b | %b | %b | %03b | %02b | %02b | %02h | %02h | %02h",
            $time,
            dut.pc,
            dut.instr,
            dut.instr[15:13],       // opcode
            dut.ctrl.RegWrite,
            dut.ctrl.ALUSrc,
            dut.ctrl.ALUfn,
            dut.instr[10:8],        // RA
            dut.instr[7:5],         // RB
            dut.alu_b,
            dut.alu_out,
            dut.mem_out
        );

        if (cycle > 200) $finish; // stop after some cycles
    end
endmodule
