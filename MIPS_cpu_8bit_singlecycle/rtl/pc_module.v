module pc_module(
    input wire clk,
    input wire rst,
    input wire [7:0] next_pc,
    output reg [7:0] pc
);
    always @(negedge clk or posedge rst) begin
        if (rst)
            pc <= 8'b0;
        else
            pc <= next_pc;
    end
endmodule
