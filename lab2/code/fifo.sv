`timescale 1ns / 1ps

module fifo 
#(
    parameter DATA_WIDTH = 8, 
    parameter PTR_WIDTH = 3 
)
(
    input clock,               
    input reset,              
    input [DATA_WIDTH-1:0] din, 
    input push,               
    input pop,               
    output reg [DATA_WIDTH-1:0] dout, 
    output wire empty,      
    output wire full
    );
    reg [PTR_WIDTH-1:0] read_pointer;
    reg [PTR_WIDTH-1:0] write_pointer;
    reg read_flag, write_flag; 
    reg [DATA_WIDTH-1:0] mem [0:(2**PTR_WIDTH)-1];

    assign empty = (read_pointer == write_pointer) && (read_flag == write_flag);
    assign full = (read_pointer == write_pointer) && (read_flag != write_flag);

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            read_pointer <= 0;
            write_pointer <= 0;
            read_flag <= 0;
            write_flag <= 0;
            dout <= 0;
        end else begin
            if (push && pop) begin
                dout <= mem[read_pointer];
                read_pointer <= (read_pointer + 1) % (2**PTR_WIDTH);
                mem[write_pointer] <= din;
                write_pointer <= (write_pointer + 1) % (2**PTR_WIDTH);
            end else if (push && !full) begin
                mem[write_pointer] <= din;
                write_pointer <= (write_pointer + 1) % (2**PTR_WIDTH);
                if (write_pointer == 0) write_flag <= ~write_flag; 
            end else if (pop && !empty) begin
                dout <= mem[read_pointer];
                read_pointer <= (read_pointer + 1) % (2**PTR_WIDTH);
                if (read_pointer == 0) read_flag <= ~read_flag; 
            end
        end
    end
endmodule
