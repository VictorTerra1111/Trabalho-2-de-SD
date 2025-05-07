module Jogo_top(
    input logic [3:0] code,
    input logic reset, clock, enter_button,
    output logic [5:0] d1, d2, d3, d4, d5, d6, d7, d8
);

    logic [5:0] d1, d2, d3, d4, d5, d6, d7, d8;

    dspl_drv_NexysA7 display(
        .clock(clock),
        .reset(reset),
        .d1(d1), 
        .d2(d2), 
        .d3(d3), 
        .d4(d4),
        .d5(d5), 
        .d6(d6), 
        .d7(d7), 
        .d8(d8),
        .an(an),
        .dec_ddp(seg)
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

endmodule