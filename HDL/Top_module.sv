module Top_module(
    input logic [15:0] SW,
    input logic reset, clock, ssl,
    output logic [15:0] LED,
    output logic [7:0] an,
    output logic [7:0] dec_ddp
);

    wire p1_win_pulse, p2_win_pulse;
    logic [5:0] d1, d2, d3, d4, d5, d6, d7, d8,

    dspl_drv_NexysA7 display(
        .clock(clock),
        .reset(reset),
        .d1(d1), .d2(d2), .d3(d3), .d4(d4),
        .d5(d5), .d6(d6), .d7(d7), .d8(d8),
        .an(an),
        .dec_ddp(dec_ddp)
    );

    BullsCows game (
        .SW(SW),
        .clock(clock),
        .reset(reset),
        .ssl(ssl),
        .d1(d1), .d2(d2), .d3(d3), .d4(d4),
        .d5(d5), .d6(d6), .d7(d7), .d8(d8),
        .p1_win(p1_win_pulse),
        .p2_win(p2_win_pulse)
    );

    pontuacao pontos (
        .clock(clock),
        .reset(reset),
        .p1vic(p1_win_pulse),
        .p2vic(p2_win_pulse),
        .LED(LED)
    );

endmodule
