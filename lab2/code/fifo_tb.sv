`timescale 1ns / 1ps

module fifo_golden_tb;
    reg clock;
    reg reset;
    reg [7:0] din;
    reg push;
    reg pop;
    wire [7:0] dout;
    wire empty;
    wire full;

    fifo #(.DATA_WIDTH(8), .PTR_WIDTH(3)) uut (
        .clock(clock),
        .reset(reset),
        .din(din),
        .push(push),
        .pop(pop),
        .dout(dout),
        .empty(empty),
        .full(full)
    );

    always #5 clock = ~clock;
    initial begin
        clock = 0;
        reset = 1;
        push = 0;
        pop = 0;
        din = 0;
        // 1. Сброс FIFO
        #10 reset = 0;
        $display("TEST 1: Reset");
        $display("Checking empty and full flags...");
        if (empty !== 1 || full !== 0)
            $display("FAILED: FIFO is not empty after reset!");
        else
            $display("PASSED");
        // 2. Запись в FIFO
        $display("TEST 2: Push data into FIFO");
        din = 8'hAA; push = 1; #10; push = 0; #10;
        din = 8'hBB; push = 1; #10; push = 0; #10;
        din = 8'hCC; push = 1; #10; push = 0; #10;
        din = 8'hDD; push = 1; #10; push = 0; #10;
        if (full !== 0)
            $display("FAILED: FIFO should not be full after 4 pushes!");
        else
            $display("PASSED");
        // 3. Чтение из FIFO
        $display("TEST 3: Pop data from FIFO");
        pop = 1; #10; pop = 0; #10;
        if (dout !== 8'hAA) $display("FAILED: Expected 0xAA, got 0x%h", dout);
        pop = 1; #10; pop = 0; #10;
        if (dout !== 8'hBB) $display("FAILED: Expected 0xBB, got 0x%h", dout);
        pop = 1; #10; pop = 0; #10;
        if (dout !== 8'hCC) $display("FAILED: Expected 0xCC, got 0x%h", dout);
        pop = 1; #10; pop = 0; #10;
        if (empty !== 1)
            $display("FAILED: FIFO should be empty after 4 pops!");
        else
            $display("PASSED");
        // 4. Проверка состояния "empty"
        $display("TEST 4: Empty signal");
        if (empty !== 1) $display("FAILED: Empty signal should be high!");
        else $display("PASSED");
        // 5. Переполнение FIFO
        $display("TEST 5: Full signal");
        din = 8'h11; push = 1; #10; push = 0; #10;
        din = 8'h22; push = 1; #10; push = 0; #10;
        din = 8'h33; push = 1; #10; push = 0; #10;
        din = 8'h44; push = 1; #10; push = 0; #10;
        din = 8'h55; push = 1; #10; push = 0; #10;
        din = 8'h66; push = 1; #10; push = 0; #10;
        din = 8'h77; push = 1; #10; push = 0; #10;
        din = 8'h88; push = 1; #10; push = 0; #10;
        if (full !== 1 && empty !== 0)
            $display("FAILED: Full signal should be high!");
        else
            $display("PASSED");
        // 6. Попытка записи в полный FIFO
        $display("TEST 6: Attempt to push into full FIFO");
        din = 8'h99; push = 1; #10; push = 0;
        if (full !== 1 && empty !== 0)
            $display("FAILED: FIFO should remain full!");
        else
            $display("PASSED");
        // 7. Попытка чтения из пустого FIFO
        $display("TEST 7: Read from empty FIFO");
        reset = 1; #10 reset = 0; #10;
        pop = 1; #10; pop = 0; #10;
        if (empty !== 1)
            $display("FAILED: FIFO should be empty!");
        else
            $display("PASSED");
        // 8. Одновременный push и pop
        $display("TEST 8: Simultaneous Push and Pop");
        din = 8'hAA; push = 1; #10;
        din = 8'hBB; pop = 1; #10;
        pop = 0; push = 0;
        if (dout !== 8'hAA)
            $display("FAILED: Simultaneous push/pop failed!");
        else
            $display("PASSED");
        // Завершение
        #50 $finish;
    end
endmodule
