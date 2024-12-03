`timescale 1ns / 1ps

module debounce (
    input wire clk,
    input wire btn_in,
    output reg pulse_out
);
    reg [15:0] counter;
    reg btn_sync_0, btn_sync_1, signal, signal_in_d;

    always @(posedge clk) begin
        btn_sync_0 <= btn_in;
        btn_sync_1 <= btn_sync_0;

        if (btn_sync_1 == signal)
            counter <= 0;
        else begin
            counter <= counter + 1;
            if (counter == 16'hFFFF)
                signal <= btn_sync_1;
        end
    end

    always @(posedge clk) begin
        signal_in_d <= signal;
        pulse_out <= signal & ~signal_in_d;
    end
endmodule