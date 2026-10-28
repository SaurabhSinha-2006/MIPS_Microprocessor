`timescale 1ns / 1ps

module program_counter(input[31:0] pc_next,
          input clk,
          input reset,
          output reg[31:0] pc);
          
always @(posedge clk or posedge reset) begin
    if (reset) begin
        pc <= 32'd0;
    end
    else begin
        pc <= pc_next;
    end
end

endmodule
