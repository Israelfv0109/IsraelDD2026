/*******************************************************************************
 * NIVEL 1: TOP LEVEL - UNIDAD MAC COMPLETA
 * Este módulo integra el Multiplicador de Booth y la Unidad de Acumulación.
 ******************************************************************************/
`timescale 1ns/1ps
module mac_top #(parameter DATA_WIDTH = 16) (
    input logic clk, rst_n, start, clr_acc,
    input logic [DATA_WIDTH-1:0] A_in, B_in,
    input logic [39:0] Accumulator,
    input logic ready_mac
);
    logic [2*DATA_WIDTH-1:0] internal_product;
    logic mult_done;

endmodule