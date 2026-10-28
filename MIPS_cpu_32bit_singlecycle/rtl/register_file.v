module register_file(
    input clk,
    input we,
    input [4:0] ra1, ra2, wa,
    input [31:0] wd,
    output [31:0] rd1, rd2
);

    reg [31:0] rf[31:0];
    integer i;

    // ✅ INITIALIZATION
    initial begin
        for (i = 0; i < 32; i = i + 1)
            rf[i] = 32'd0;
    end

    // synchronous write
    always @(posedge clk) begin
        if (we && (wa != 0))
            rf[wa] <= wd;
    end

    // combinational read
    assign rd1 = rf[ra1];
    assign rd2 = rf[ra2];

endmodule
