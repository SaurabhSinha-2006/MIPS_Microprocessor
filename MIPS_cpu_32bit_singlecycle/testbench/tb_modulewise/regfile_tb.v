`timescale 1ns / 1ps

module regfile_tb();

    reg clk = 0;
    always #5 clk = ~clk;
    
    reg we;
    reg[4:0] ra1, ra2, wa;
    reg[31:0] wd;
    wire[31:0] rd1, rd2;
    
    register_file uut( .clk(clk),
                       .we(we),
                       .ra1(ra1), .ra2(ra2), .wa(wa),
                       .wd(wd),
                       .rd1(rd1), .rd2(rd2));
                       
    initial 
        begin
            //Test 1 $zero behavior
            we = 1; wa = 5'b0; wd = 32'hFFFFFFFF; ra1 = 5'b0;
            @(posedge clk);
            we = 0;
            #1; // to settle the read the value
            if (rd1 !== 32'h0) $display("ERROR! zero register was modified to: %h", rd1);
            else $display ("Zero register working fine");
            
            //Test 2 write register 1 and read back
            we = 1; wa = 5'd1; wd = 32'hAAAABBBB;
            @(posedge clk);
            #1;
            we = 0; ra1 = 32'd1;
            #1;
            if ( rd1 !== 32'hAAAABBBB) $display("ERROR! reg1 mismatch: %h", rd1);
            else $display ("Written successfully!! : %h", rd1);
            
            //Test 3 multiple read and write
            // Write reg2 and reg3 in separate cycles
            we = 1; wa = 2; wd = 32'h0000_0002;
            @(posedge clk);
            #1;
            we = 1; wa = 3; wd = 32'h0000_0003;
            @(posedge clk);
            #1;
            we = 0; ra1 = 2; ra2 = 3;
            #1;
            if (rd1 !== 32'h2 || rd2 !== 32'h3)
              $display("ERROR: multiple regs mismatch r1=%h r2=%h", rd1, rd2);
            else
              $display("OK: multiple regs correct r1=%h r2=%h", rd1, rd2);
              
            //Test 4
            
            
            $display ("All test done");
            #10;
            $finish;
        end

endmodule