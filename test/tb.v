`default_nettype none
`timescale 1ns / 1ps

module tb ();

  // Dump signals for waveform analysis
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end

  // Clock generation
  reg clk;
  initial clk = 0;
  always #5 clk = ~clk;  // 10ns clock period (100MHz)

  // Declare inputs and outputs
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_oe;

  // Instantiate the module under test
  tt_um_rect_cyl user_project (
      .ui_in  (ui_in),    // x input
      .uio_in (uio_in),   // y input
      .uo_out (uo_out),   // r output
      .uio_oe (uio_oe),   // IO enable
      .ena    (ena),      // enable signal
      .clk    (clk),      // clock signal
      .rst_n  (rst_n)     // active-low reset
  );

  // Test sequence
  initial begin
    // Initialize signals
    rst_n = 0;
    ena = 1;
    ui_in = 0;
    uio_in = 0;
    #50;  // Hold reset for 50ns

    rst_n = 1;  // Release reset
    
    // Apply test inputs
    #20 ui_in = 8'd3;  uio_in = 8'd4;  #50;
    $display("Time=%0t | x=%d, y=%d | r=%d (Expected: 5)", $time, ui_in, uio_in, uo_out);
    
    #20 ui_in = 8'd5;  uio_in = 8'd12; #50;
    $display("Time=%0t | x=%d, y=%d | r=%d (Expected: 13)", $time, ui_in, uio_in, uo_out);
    
    #20 ui_in = 8'd0;  uio_in = 8'd10; #50;
    $display("Time=%0t | x=%d, y=%d | r=%d (Expected: 10)", $time, ui_in, uio_in, uo_out);
    
    #20 ui_in = 8'd10; uio_in = 8'd0;  #50;
    $display("Time=%0t | x=%d, y=%d | r=%d (Expected: 10)", $time, ui_in, uio_in, uo_out);
    
    #20 ui_in = 8'd7;  uio_in = 8'd24; #50;
    $display("Time=%0t | x=%d, y=%d | r=%d (Expected: 25)", $time, ui_in, uio_in, uo_out);
    
    #50 $finish;
  end

endmodule
