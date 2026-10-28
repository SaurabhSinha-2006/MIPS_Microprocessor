`timescale 1ns / 1ps

module left_shift_2 (
    input  [31:0] in,   // Input data (e.g. sign-extended immediate)
    output [31:0] out   // Output after shifting left by 2
);
    assign out = in << 2;  // Shift left by 2 bits
endmodule
