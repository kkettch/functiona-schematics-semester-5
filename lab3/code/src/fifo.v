module fifo 
#(
    parameter DATA_WIDTH = 16,      // --CHANGED
    parameter PTR_WIDTH = 2         // --CHANGED     
)
(
    input clk,                       
    input [DATA_WIDTH-1:0] din, 
    input push,               
    input pop,               
    output reg [DATA_WIDTH-1:0] dout
    );

    reg [PTR_WIDTH-1:0] read_pointer;
    reg [PTR_WIDTH-1:0] write_pointer;
    reg read_flag, write_flag; 
    reg [DATA_WIDTH-1:0] mem [0:(2**PTR_WIDTH)-1];
    integer i;

    assign empty = (read_pointer == write_pointer) && (read_flag == write_flag);
    assign full = (read_pointer == write_pointer) && (read_flag != write_flag);

    // --ADDED
    initial begin
        read_flag = 0;
        write_flag = 0;
        read_pointer = 0;
        write_pointer = 0;
    end

    always @(posedge clk) begin

        if (push && !full) begin
            mem[write_pointer] = din;
            write_pointer = (write_pointer + 1) % (1 << PTR_WIDTH);
            if (write_pointer == 0) write_flag = ~write_flag; 
        end

        if (pop && !empty) begin
            read_pointer = (read_pointer + 1) % (1 << PTR_WIDTH);
            if (read_pointer == 0) read_flag = ~read_flag;  
        end
    end

    always @(*) begin
        if (pop && !empty) begin
            dout = mem[read_pointer];
            mem[read_pointer] = 0;
        end
    end

endmodule
