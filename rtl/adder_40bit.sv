`timescale 1ns/1ps

module adder_40bit (
    input  logic signed [39:0] a,
    input  logic signed [39:0] b,
    output logic signed [39:0] sum
);
    assign sum = a + b;
endmodule