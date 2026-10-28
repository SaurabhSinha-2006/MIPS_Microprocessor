`timescale 1ns / 1ps

module instruction_memory(input[31:0] addr,
                          output[31:0] instr);
                          
    reg[31:0] mem[255:0];
    
    initial begin
    //For more practical appproach use a external file and then load
    //$readmemh("instr_mem.mem",mem);
    
    //for now just hardcode it
        mem[0] = 32'h20080005;  // addi $t0, $zero, 5
        mem[1] = 32'h2009000A;  // addi $t1, $zero, 10
        mem[2] = 32'h01095020;  // add  $t2, $t0, $t1
        mem[3] = 32'hAC0A0000;  // sw   $t2, 0($zero)
        mem[4] = 32'h8C0B0000;  // lw   $t3, 0($zero)
        mem[5] = 32'h012A5822;  // sub  $t3, $t1, $t2
        mem[6] = 32'h08000006;  // j    0x00000006 (loop)

    end
    
    assign instr = mem[addr[9:2]];

endmodule
