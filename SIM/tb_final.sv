`timescale 1ns/1ps

module tb_final #();


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

    #stop
  end

endmodule: tb_final