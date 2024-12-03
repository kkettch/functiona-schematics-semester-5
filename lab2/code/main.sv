`timescale 1ns / 1ps

module main(
    input logic [7:0] SW,
    input logic CLK100MHZ,
    input logic BTNR,
    input logic BTNL,
    input logic BTNC,
    output logic [7:0] AN,
    output logic [6:0] SEG,
    output logic [15:0] LED,
    output logic LED16_R, LED17_G
    );

    logic [6:0] segments [0:15];
    logic [3:0] current_digit;
    logic [2:0] active_digit;      
    logic [7:0] display_data;

    parameter integer REFRESH_RATE_HZ = 10000;
    integer refresh_counter = 0;

    logic [7:0] dout;

    wire clk_1khz, clk_1hz;
    reg push_reg, pop_reg;
    wire push_edge, pop_edge;

    freq_divider #(.DIVIDER(50000)) divider_1khz (
        .rst(BTNC),
        .clk_in(CLK100MHZ),
        .clk_out(clk_1khz)
    );

    debounce push_debounce (
        .clk(CLK100MHZ),
        .btn_in(BTNR),
        .pulse_out(push_reg)
    );

    debounce pop_debounce (
        .clk(CLK100MHZ),
        .btn_in(BTNL),
        .pulse_out(pop_reg)
    );

//    edge_detector push_edge_det (
//        .clk(CLK100MHZ),
//        .signal_in(push_reg),
//        .pulse_out(push_edge)
//    );

//    edge_detector pop_edge_det (
//        .clk(CLK100MHZ),
//        .signal_in(pop_reg),
//        .pulse_out(pop_edge)
//    );

    fifo fifo_inst (
        .clock(CLK100MHZ),
        .reset(BTNC),
        .push(push_reg),
        .pop(pop_reg),
        .din(SW[7:0]),
        .dout(dout),
        .empty(LED17_G),
        .full(LED16_R)
    );
    
    initial begin
        segments[0]  = 7'b1000000; // 0
        segments[1]  = 7'b1111001; // 1
        segments[2]  = 7'b0100100; // 2
        segments[3]  = 7'b0110000; // 3
        segments[4]  = 7'b0011001; // 4
        segments[5]  = 7'b0010010; // 5
        segments[6]  = 7'b0000010; // 6
        segments[7]  = 7'b1111000; // 7
        segments[8]  = 7'b0000000; // 8
        segments[9]  = 7'b0010000; // 9
        segments[10] = 7'b0001000; // A
        segments[11] = 7'b0000011; // B
        segments[12] = 7'b1000110; // C
        segments[13] = 7'b0100001; // D
        segments[14] = 7'b0000110; // E
        segments[15] = 7'b0001110; // F
    end

    always_ff @(posedge CLK100MHZ) begin
        if (BTNL) begin
            display_data <= dout;      
        end
        if (BTNC) begin
            display_data <= 8'b00000000;
        end
    end

    always_ff @(posedge CLK100MHZ) begin
        if (refresh_counter >= (50_000_000 / (8 * REFRESH_RATE_HZ))) begin
            refresh_counter <= 0;
            active_digit <= (active_digit + 1) % 8;
        end else begin
            refresh_counter <= refresh_counter + 1;
        end
    end

    always_comb begin
        case (active_digit)
            3'b000: current_digit = display_data[7:4]; 
            3'b001: current_digit = display_data[3:0]; 
            default: current_digit = 4'b0000; 
        endcase
    end

    always_comb begin
        AN = 8'b11111111;  
        case (active_digit)
            3'b000: AN = 8'b11111101;  
            3'b001: AN = 8'b11111110;  
            3'b010: AN = 8'b11111011;  
            3'b011: AN = 8'b11110111;
            3'b100: AN = 8'b11101111; 
            3'b101: AN = 8'b11011111; 
            3'b110: AN = 8'b10111111;  
            3'b111: AN = 8'b01111111;  
        endcase
        SEG = segments[current_digit]; 
    end
endmodule
