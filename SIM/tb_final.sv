`timescale 1ns/1ps


module tb_final #();

  logic reset, clock, enter_button;
  logic [5:0] d1, d2, d3, d4, d5, d6, d7, d8;
  logic [15:0] led, code;
  logic [7:0] an, seg;

  Top_module top(
    .reset(reset),
    .clock(clock),
    .enter_button(enter_button),
    .d1(d1), .d2(d2), .d3(d3), .d4(d4), .d5(d5), .d6(d6), .d7(d7), .d8(d8),
    .led(led),
    .an(an),
    .seg(seg),
    .code(code)
  );

  //falta pra baixo

  initial clock = 0;
  always #5 clock = ~clock;

  initial begin
    #10
    reset = 0;
    #10 
    reset = 1;
    #10
    reset = 0;
    #10

    $finish;
  end

endmodule