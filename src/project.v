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

    reg [15:0] x2, y2, r_squared;
    reg [7:0] r_reg;
    reg [7:0] sqrt_estimate; // Iterative square root estimate

    // Function to compute an approximate square root using Newton-Raphson
    function [7:0] sqrt_approx;
        input [15:0] value;
        reg [7:0] temp, result;
        begin
            result = 8'd1;
            repeat (6) begin // Iterative approximation
                temp = (result + value / result) >> 1;
                result = temp;
            end
            sqrt_approx = result;
        end
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x2 <= 16'd0;
            y2 <= 16'd0;
            r_squared <= 16'd0;
            r_reg <= 8'd0;
        end else if (ena) begin
            // Compute squared values
            x2 <= ui_in * ui_in;
            y2 <= uio_in * uio_in;
            r_squared <= x2 + y2;

            // Compute square root using iterative approximation
            sqrt_estimate <= sqrt_approx(r_squared);
            r_reg <= sqrt_estimate;
        end
    end

    // Outputs
    assign uo_out = r_reg;      // Magnitude output (r)
    assign uio_oe = 8'b11111111; // Set all IOs to output mode

endmodule
