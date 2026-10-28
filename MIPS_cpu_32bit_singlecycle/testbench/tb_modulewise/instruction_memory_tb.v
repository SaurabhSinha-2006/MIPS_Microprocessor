`timescale 1ns / 1ps

module instruction_memory_tb();
    
    reg[31:0] addr;
    wire[31:0] instr;
    
    instruction_memory uut(.addr(addr),
                       .instr(instr));
                       
                       
    initial begin
    
//        $dumpfile("instr_mem.vcd");
//        $dumpvars(0, instruction_memory_tb);
    
        addr = 0; #10;
        $display("address = %h, instruction = %h", addr, instr);
        
        addr = 4; #10;
        $display("address = %h, instruction = %h", addr, instr);
        
        addr = 8; #10;
        $display("address = %h, instruction = %h", addr, instr);
        
        addr = 12; #10;
        $display("address = %h, instruction = %h", addr, instr);
        
        $display("All test done!!");
        #10;
        $finish;

    end
endmodule
