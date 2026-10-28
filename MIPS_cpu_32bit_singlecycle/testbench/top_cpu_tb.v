`timescale 1ns / 1ps

module cpu_top_tb;

    reg clk;
    reg reset;

    // Instantiate DUT
    cpu_top uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock: 10ns period
    always #5 clk = ~clk;

    initial begin
        $display("\n======= CPU SIMULATION START =======\n");

        clk = 0;
        reset = 1;
        #10;

        reset = 0;

        // Run long enough for instructions
        #300;

        $display("\n======= CPU SIMULATION END =======\n");
        $finish;
    end

    // Main CPU monitor
    always @(posedge clk) begin
        $display("T=%0t | PC=%08h | INSTR=%08h | ALUOUT=%08h | WD=%08h | RD=%08h | ZERO=%b | MEMW=%b | REGW=%b",
            $time,
            uut.dp.pc,
            uut.instr,
            uut.aluout,
            uut.writedata,
            uut.readdata,
            uut.zero,
            uut.memwrite,
            uut.regwrite
        );
    end

    // Memory write monitor
    always @(posedge clk) begin
        if (uut.memwrite) begin
            $display(">>> MEM WRITE @%08h = %08h", uut.aluout, uut.writedata);
        end
    end

endmodule
