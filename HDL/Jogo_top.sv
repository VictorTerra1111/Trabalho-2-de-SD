module Jogo_top(
    input logic [3:0] code,
    input logic reset, clock, enter_button,
    output logic [5:0] d1, d2, d3, d4, d5, d6, d7, d8
);

    wire 

    dspl_drv_NexysA7 display_fpga(
        .clock(clock),
        .reset(reset),
        .d1(d1), 
        .d2(d2), 
        .d3(d3),
        .d4(d4), 
        .d5(d5), 
        .d6(d6), 
        .d7(d7), 
        .d8(d8)
    );
    

    BullsCows jogo(
        .code(code),
        .clock(clock),
        .reset(reset),
        .enter_button(enter_button),
        .d1(d1), 
        .d2(d2), 
        .d3(d3), 
        .d4(d4), 
        .d5(d5), 
        .d6(d6), 
        .d7(d7), 
        .d8(d8)
    );


    assign d1 = {a[1], b[1], c[1], d[1], e[1], f[1], g[1]};
    // exemplo de como fazer nofuturo
endmodule