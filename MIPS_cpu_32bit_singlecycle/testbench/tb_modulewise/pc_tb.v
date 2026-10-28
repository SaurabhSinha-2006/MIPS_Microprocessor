`timescale 1ns / 1ps
module pc_tb();

    wire[31:0] pc;
    reg clk = 0, reset;
    reg[31:0] pc_next;
    
program_counter uut(.pc(pc), 
       .clk(clk), 
       .reset(reset),
       .pc_next(pc_next));
       
    always #5 clk = ~clk;   
       
    initial 
    begin
        $monitor("Time=%0t | clk=%b | reset=%b | pc_next=%h | pc=%h", $time, clk, reset, pc_next, pc);

        reset = 1; pc_next = 32'h00000000; @(posedge clk);
        reset = 0; pc_next = 32'h00000004; @(posedge clk);
        pc_next = 32'h00000008; @(posedge clk);
        pc_next = 32'h0000000C; @(posedge clk);
        pc_next = 32'h00000010; @(posedge clk);

        $display("Simulation Complete");
        $finish;
    end

endmodule
