`timescale 1ns / 1ps

module alu_tb();

    reg[31:0] a, b;
    reg[2:0] ctr;
    wire[31:0] result;
    wire zero;
    
    alu uut(.a(a), .b(b),
            .ctr(ctr),
            .result(result),
            .zero(zero));
            
    initial 
    begin 
        //test 1 add
        a = 32'hAAAA_BBBB; b = 32'hAAAA_BBBB; ctr = 3'b010;
        #10;
        if (result !== 32'h5555_7776)
            $display("ERROR! add result = %h", result);
        
        //test 2 sub
        a = 32'h0000_000F; b = 32'h0000_000A; ctr = 3'b110;
        #10;
        if (result !== 32'h0000_0005)
            $display("ERROR! sub result = %h", result);
            
        //test 3 and
        a = 32'h0000_00AB; b = 32'h0000_0012; ctr = 3'b000;
        #10;
        if (result !== 32'h0000_0002)
            $display("ERROR! and result = %h", result);
            
        //test 4 or
        a = 32'h0000_0032; b = 32'h0000_0009; ctr = 3'b001;
        #10;
        if (result !== 32'h0000_003B)
            $display("ERROR! or result = %h", result);
            
        $display("All test done");
        #10;
        $finish;
    end
        
endmodule
