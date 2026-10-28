// data_mem.v - 256 x 8 RAM
`timescale 1ns/1ps
module data_mem (
    input  wire clk,
    input  wire we,           // write enable
    input  wire [7:0] addr,   // byte address
    input  wire [7:0] wdata,
    output reg  [7:0] rdata
);
    reg [7:0] ram [0:255];
    integer i;
    initial begin
        for (i=0;i<256;i=i+1) ram[i] = 8'b0;
    end

    always @(posedge clk) begin
        if (we) ram[addr] <= wdata;
        rdata <= ram[addr];
    end
endmodule
