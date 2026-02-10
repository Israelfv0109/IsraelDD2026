`timescale 1ns/1ps

module booth_multiplier #(parameter DATA_WIDTH = 16) (
    input  logic clk, rst_n, start,
    input  logic [DATA_WIDTH-1:0] m_in, q_in,
    output logic [2*DATA_WIDTH-1:0] result,
    output logic ready
);
    // Señales de interconexión interna
    logic load, shift, op_sel;

    // Instancia de la FSM (Unidad de Control)
    booth_fsm #(.DATA_WIDTH(DATA_WIDTH)) control_unit (
        .clk(clk), .rst_n(rst_n), .start(start),
        .load(load), .shift(shift), .op_sel(op_sel), .ready(ready)
    );

    // Instancia del Datapath (Unidad Aritmética)
    booth_datapath #(.DATA_WIDTH(DATA_WIDTH)) arithmetic_unit (
        .clk(clk), .rst_n(rst_n), .m_in(m_in), .q_in(q_in),
        .load(load), .shift(shift), .op_sel(op_sel), .product(result)
    );
endmodule