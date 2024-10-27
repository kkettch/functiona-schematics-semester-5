`timescale 1ns / 1ps

module comparator(
    input a0,
    input a1,
    input a2,
    input a3,

    input b0,
    input b1,
    input b2,
    input b3,
    
    output a_greater_b,
    output a_equals_b,
    output a_smaller_b
);

    wire not_b0, not_b1, not_b2, not_b3;
    wire xnor_0, xnor_1, xnor_2, xnor_3;
    wire an0, an1, an2, an3;
    wire and_greater_0, and_greater_1, and_greater_2;

    not(not_b0, b0);
    not(not_b1, b1);
    not(not_b2, b2);
    not(not_b3, b3);

    xnor(xnor_0, a0, b0);
    xnor(xnor_1, a1, b1);
    xnor(xnor_2, a2, b2);
    xnor(xnor_3, a3, b3);

    and(and_0, a0, not_b0);
    and(and_1, a1, not_b1);
    and(and_2, a2, not_b2);
    and(and_3, a3, not_b3);

    and(and_greater_0, and_0, xnor_1, xnor_2, xnor_3);
    and(and_greater_1, and_1, xnor_2, xnor_3);
    and(and_greater_2, and_2, xnor_3);

    and(a_equals_b, xnor_0, xnor_1, xnor_2, xnor_3);
    or(a_greater_b, and_greater_0, and_greater_1, and_greater_2, and_3);
    nor(a_smaller_b, a_equals_b, a_greater_b);
endmodule