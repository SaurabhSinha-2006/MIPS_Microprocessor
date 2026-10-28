// tb_cpu.v - simple testbench that reads imem.hex and runs for a number of cycles
`timescale 1ns/1ps
module tb_cpu;
    reg clk;
    reg rst;
    wire [7:0] pc_out;
    wire [15:0] instr_out;
    wire [7:0] alu_out;
    wire [7:0] mem_out;

    cpu_top dut(.clk(clk), .rst(rst), .pc_out(pc_out), .instr_out(instr_out), .alu_out(alu_out), .mem_out(mem_out));

    initial begin
        clk = 0; rst = 1;
        #12 rst = 0;
        #2000 $finish;
    end

    always #5 clk = ~clk;

    initial begin
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, tb_cpu);
        $display("time | pc | instr | alu | mem");
        $monitor("%0t | %0h | %0h | %0h | %0h", $time, pc_out, instr_out, alu_out, mem_out);
    end
endmodule
