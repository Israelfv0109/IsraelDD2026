`timescale 1ns/1ps

module accumulator_unit (
    input  logic clk, rst_n, acc_en,
    input  logic signed [`MAC_ACC_WIDTH-1:0] product_in,
    output logic signed [`MAC_ACC_WIDTH-1:0] acc_out
);
    logic signed [`MAC_ACC_WIDTH-1:0] current_sum, acc_reg;

    // Instancia del sumador de 40 bits
    adder_40bit mac_adder (.a(product_in), .b(acc_reg), .sum(current_sum));
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)         acc_reg <= '0;
        else if (acc_en)    acc_reg <= current_sum;
    end

    assign acc_out = acc_reg;
endmodule
