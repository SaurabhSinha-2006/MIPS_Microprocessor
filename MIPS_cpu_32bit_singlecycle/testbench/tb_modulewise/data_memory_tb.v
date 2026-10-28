`timescale 1ns / 1ps

module data_memory_tb();

    reg clk = 0;
    reg we;
    reg[31:0] addr;
    reg[31:0] wd;
    wire[31:0] rd;
    
    data_memory uut(.clk(clk), 
                    .we(we),
                    .addr(addr),
                    .wd(wd),
                    .rd(rd));
                    
    always #5 clk = ~clk;
                    
    initial begin
    //test 1 :  write
        we = 1; addr = 32'h0000_0004; wd = 32'h0000_ABCD;
        @(posedge clk);
        #1;
        we = 0;
        #1;
        
    //test 2 : read 
        addr = 32'h0000_0004;
        #1;
        $display(" Read Data = %h", rd);
        
        #2;
        $display("ALL TEST DONE!!!");
        $finish;
    end
        
endmodule
