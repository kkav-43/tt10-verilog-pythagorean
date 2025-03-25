`default_nettype none
`timescale 1ns/1ps

module tt_um_rect_cyl (
    input  wire [7:0] ui_in,   // x input
    input  wire [7:0] uio_in,  // y input
    output wire [7:0] uo_out,  // r output
    output wire [7:0] uio_oe,  // IO enable (set to output mode)
    input  wire       ena,     // Enable signal
    input  wire       clk,     // Clock signal
    input  wire       rst_n    // Active-low reset
);

    // Use localparam for design constants
    localparam SQRT_ITERATIONS = 6;

    // Improved variable declarations with more explicit types
    logic [15:0] x2, y2, r_squared;
    logic [7:0] r_reg;
    logic [7:0] sqrt_estimate;

    // Function to compute an approximate square root more efficiently
    function automatic logic [7:0] sqrt_approx(input logic [15:0] value);
        logic [7:0] result, temp;
        begin
            result = 8'd1;
            for (int i = 0; i < SQRT_ITERATIONS; i++) begin
                temp = (result + value / result) >> 1;
                result = temp;
            end
            return result;
        end
    endfunction

    // Synchronous logic with more explicit reset handling
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x2 <= '0;
            y2 <= '0;
            r_squared <= '0;
            r_reg <= '0;
        end else if (ena) begin
            // Compute squared values using explicit multiply
            x2 <= ui_in * ui_in;
            y2 <= uio_in * uio_in;
            r_squared <= x2 + y2;

            // Compute square root using approximation
            sqrt_estimate <= sqrt_approx(r_squared);
            r_reg <= sqrt_estimate;
        end
    end

    // Outputs with explicit assignment
    assign uo_out = r_reg;      // Magnitude output (r)
    assign uio_oe = 8'b11111111; // Set all IOs to output mode

endmodule
