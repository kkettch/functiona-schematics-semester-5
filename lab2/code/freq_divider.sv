`timescale 1ns / 1ps

module freq_divider #(
    parameter DIVIDER = 50000
)(
    input wire rst,
    input wire clk_in,
    output reg clk_out = 0
);

    reg [31:0] counter = 0;

    always @(posedge clk_in) begin
        if (rst) begin
            counter <= 0;
            clk_out <= 0;
        end else if (counter == DIVIDER - 1) begin
            counter <= 0;
            clk_out <= ~clk_out;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule