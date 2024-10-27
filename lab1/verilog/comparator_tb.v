`timescale 1ns / 1ps

module comparator_tb;

    // инициализация используемых переменных/проводов
    reg a0_in, a1_in, a2_in, a3_in, b0_in, b1_in, b2_in, b3_in;
    wire result_equals_out, result_smaller_out, result_greater_out;

    // объявление битов компаратора
    comparator comparator_1(
        .a0(a0_in),
        .a1(a1_in),
        .a2(a2_in),
        .a3(a3_in),

        .b0(b0_in),
        .b1(b1_in),
        .b2(b2_in),
        .b3(b3_in),

        .a_equals_b(result_equals_out),
        .a_greater_b(result_greater_out),
        .a_smaller_b(result_smaller_out)
    );

    integer i, j;
    reg [3:0] test_a, test_b;
    reg expected_eq, expected_gr, expected_low;

    initial begin
        $display("Starting comparator test...");

        for (i = 0; i < 16; i = i + 1) begin
            test_a = i;
            a0_in = test_a[0];
            a1_in = test_a[1];
            a2_in = test_a[2];
            a3_in = test_a[3];
            
            for (j = 0; j < 16; j = j + 1) begin
                test_b = j;
                b0_in = test_b[0];
                b1_in = test_b[1];
                b2_in = test_b[2];
                b3_in = test_b[3];

                // задержка в 10 нс, чтобы сигнал распространился
                #10;

                // ожидаемые результаты
                expected_eq = (test_a == test_b);
                expected_gr = (test_a > test_b);
                expected_low = (test_a < test_b);

                // проверка совпадения ожидаемого результата и фактического
                if (result_equals_out !== expected_eq || 
                    result_greater_out !== expected_gr || 
                    result_smaller_out !== expected_low) begin
                    $display("Test failed for a=%b, b=%b. Expected: g=%b, e=%b, s=%b. Got: g=%b, e=%b, s=%b", 
                             test_a, test_b, 
                             expected_gr, expected_eq, expected_low, 
                             result_greater_out, result_equals_out, result_smaller_out);
                end else begin
                    $display("Test passed for a=%b, b=%b. g=%b, e=%b, s=%b", 
                             test_a, test_b, 
                             result_greater_out, result_equals_out, result_smaller_out);
                end
            end
        end

        $display("Comparator test completed.");
        #10 $stop;
    end
endmodule
