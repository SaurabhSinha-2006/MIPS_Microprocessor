// regfile.v - 8 registers x 8 bits
`timescale 1ns/1ps
module regfile (
    input  wire        clk,
    input  wire        we,
    input  wire [2:0]  ra,       // read port A addr
    input  wire [2:0]  rb,       // read port B addr
    input  wire [2:0]  wd_addr,  // write dest addr
    input  wire [7:0]  wd,       // write data
    output wire [7:0]  rd_a,     // read data A
    output wire [7:0]  rd_b      // read data B
);
    reg [7:0] regs [0:7];
    integer i;
    initial begin
        for (i=0;i<8;i=i+1) regs[i] = 8'b0;
    end

    // synchronous write on rising edge
    always @(negedge clk) begin
        if (we) regs[wd_addr] <= wd;
    end

    assign rd_a = regs[ra];
    assign rd_b = regs[rb];
endmodule
