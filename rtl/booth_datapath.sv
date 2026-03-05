`timescale 1ns/1ps

module booth_datapath (
    input  logic clk, rst_n,
    input  logic signed [`MAC_DATA_WIDTH-1:0] m_in, q_in,
    input  logic load, shift, op_sel,
    output logic signed [`MAC_ACC_WIDTH-1:0] product
);

    // Para 32 bits, necesitamos 1 bit extra de guarda en Q para absorber los 33 shifts totales de Radix-8 sin corromper el signo.
    localparam EXTRA_Q_BITS = (((`MAC_DATA_WIDTH + 2) / 3) * 3) - `MAC_DATA_WIDTH;
    localparam Q_WIDTH = `MAC_DATA_WIDTH + EXTRA_Q_BITS;

    logic signed [`MAC_DATA_WIDTH-1:0] A, M;
    logic signed [Q_WIDTH-1:0] Q; 
    logic q_prev;

    // ALU DE 36 BITS (Data + 4 bits extra para evitar desbordamiento en 4M y 3M)
    logic signed [`MAC_DATA_WIDTH+3:0] ext_A;
    logic signed [`MAC_DATA_WIDTH+3:0] ext_M;
    logic signed [`MAC_DATA_WIDTH+3:0] ext_M3;
    logic signed [`MAC_DATA_WIDTH+3:0] alu_out;
    
    // Extendemos el signo copiando el bit más significativo (MSB) CUATRO VECES
    assign ext_A = {{4{A[`MAC_DATA_WIDTH-1]}}, A};
    assign ext_M = {{4{M[`MAC_DATA_WIDTH-1]}}, M};

    // Generación del 3M interno (2M + 1M)
    assign ext_M3 = (ext_M <<< 1) + ext_M;

    // Multiplexor de suma/resta (Pura combinacional)
    always_comb begin
        case ({Q[2:0], q_prev})
            4'b0001, 4'b0010: alu_out = ext_A + ext_M;         // +1M
            4'b0011, 4'b0100: alu_out = ext_A + (ext_M <<< 1); // +2M
            4'b0101, 4'b0110: alu_out = ext_A + ext_M3;        // +3M
            4'b0111:          alu_out = ext_A + (ext_M <<< 2); // +4M
            4'b1000:          alu_out = ext_A - (ext_M <<< 2); // -4M
            4'b1001, 4'b1010: alu_out = ext_A - ext_M3;        // -3M
            4'b1011, 4'b1100: alu_out = ext_A - (ext_M <<< 1); // -2M
            4'b1101, 4'b1110: alu_out = ext_A - ext_M;         // -1M
            default:          alu_out = ext_A;                 // 0000, 1111
        endcase
    end

    // REGISTROS SECUENCIALES ---
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            {A, Q, q_prev} <= '0;
            M <= '0;
        end else if (load) begin
            A <= '0;
            M <= m_in;
            Q <= $signed(q_in); // Rellenamos el bit extra de Q con el signo del multiplicador
            q_prev <= 1'b0;
        end else if (op_sel && shift) begin
            // Shift aritmético de 3 bits (Radix-8)
            // Concatenamos los 35 bits necesarios de la ALU + 32 de Q + 1 de q_prev = 68 bits.
            // Al hacer >>> 3, nos quedan exactamente los 65 bits para {A, Q, q_prev}.
            {A, Q, q_prev} <= $signed({alu_out[`MAC_DATA_WIDTH+2:0], Q, q_prev}) >>> 3; 
        end
    end

    assign product = $signed({A[`MAC_DATA_WIDTH - 1 - EXTRA_Q_BITS:0], Q});

endmodule