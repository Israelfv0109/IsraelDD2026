`timescale 1ns/1ps

module booth_datapath #(parameter DATA_WIDTH = 16) (
    input  logic clk, rst_n,
    input  logic [DATA_WIDTH-1:0] m_in, q_in,
    input  logic load, shift, op_sel,
    output logic [2*DATA_WIDTH-1:0] product
);
    logic signed [DATA_WIDTH-1:0] A, M;
    logic [DATA_WIDTH-1:0] Q;
    logic q_prev;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            {A, Q, q_prev} <= '0;
            M <= '0;
        end else if (load) begin
            A <= '0;
            M <= m_in;
            Q <= q_in;
            q_prev <= 1'b0;
        end else if (op_sel && shift) begin
            // Lógica Radix-4: Miramos 3 bits y desplazamos 2
            case ({Q[1], Q[0], q_prev})
                3'b001, 3'b010: {A, Q, q_prev} <= $signed({A + M, Q, q_prev}) >>> 2;
                3'b101, 3'b110: {A, Q, q_prev} <= $signed({A - M, Q, q_prev}) >>> 2;
                3'b011:         {A, Q, q_prev} <= $signed({A + (M <<< 1), Q, q_prev}) >>> 2;
                3'b100:         {A, Q, q_prev} <= $signed({A - (M <<< 1), Q, q_prev}) >>> 2;
                default:        {A, Q, q_prev} <= $signed({A, Q, q_prev}) >>> 2;
            endcase
        end
    end

    assign product = {A, Q};
endmodule