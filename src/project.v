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

    // Internal registers for computation
    reg [15:0] x2, y2, r_squared;
    reg [7:0] r_reg;

    // Iterative square root approximation function
    function automatic [7:0] sqrt_approx(input [15:0] value);
        reg [7:0] result;
        reg [15:0] temp;
        integer i;
        begin
            result = 8'd1;
            for (i = 0; i < 8; i++) begin
                temp = (result + value / result) >> 1;
                result = temp[7:0];
            end
            return result;
        end
    endfunction

    // Main computational logic
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

            // Compute magnitude using square root approximation
            r_reg <= sqrt_approx(r_squared);
        end
    end

    // Outputs
    assign uo_out = r_reg;
    assign uio_oe = 8'b11111111; // Set all IOs to output mode

endmodule
