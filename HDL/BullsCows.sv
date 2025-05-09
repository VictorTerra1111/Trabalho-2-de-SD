module BullsCows(
    input [15:0] SW,
    input clock,
    input reset,
    input enter_button,

    output [5:0] d1, d2, d3, d4, d5, d6, d7, d8,
    output p1_win,
    output p2_win
);
    typedef enum logic [2:0] {S1, S2, T1, T2, RESULT, WIN} state_t;
    state_t state;

    reg [15:0] secret1, secret2;
    integer bulls, cows;
    reg flag_winner;  // 0: p1, 1: p2

    wire enter_rising;

    edge_detector ed (
        .clock(clock),
        .reset(reset),
        .din(enter_button),
        .rising(enter_rising)
    );

    // Função de cálculo
    task automatic calc_bulls_cows(
        input [15:0] secret, input [15:0] guess,
        output integer bulls_out, output integer cows_out
    );
        integer i, j;
        reg [3:0] s_digit [3:0], g_digit [3:0];
        bulls_out = 0;
        cows_out = 0;
        for (i = 0; i < 4; i++) begin
            s_digit[i] = secret[i*4 +: 4];
            g_digit[i] = guess[i*4 +: 4];
        end
        for (i = 0; i < 4; i++)
            if (s_digit[i] == g_digit[i]) bulls_out++;
        for (i = 0; i < 4; i++)
            for (j = 0; j < 4; j++)
                if (i != j && s_digit[i] == g_digit[j]) cows_out++;
    endtask

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            state <= S1;
            secret1 <= 0; secret2 <= 0;
            bulls <= 0; cows <= 0;
            p1_win <= 0; p2_win <= 0;
        end else begin
            // Limpa pulso após 1 ciclo
            p1_win <= 0;
            p2_win <= 0;

            case (state)
                S1: begin
                    d1 <= 6'b1100111; d2 <= 6'b0000001; // P1
                    d3 <= 6'b0000000; d4 <= 6'b1011011; // S
                    d5 <= 6'b0111110;
                    if (enter_rising) begin secret1 <= SW; state <= S2; end
                end
                S2: begin
                    d1 <= 6'b1100111; d2 <= 6'b0000010; // P2
                    d3 <= 6'b0000000; d4 <= 6'b1011011; // S
                    d5 <= 6'b0111110;
                    if (enter_rising) begin secret2 <= SW; state <= T1; end
                end
                T1: begin
                    d1 <= 6'b1100111; d2 <= 6'b0000001; // P1 G
                    d3 <= 6'b0000000; d4 <= 6'b1011111;
                    if (enter_rising) begin
                        calc_bulls_cows(secret2, SW, bulls, cows);
                        if (bulls == 4) begin flag_winner <= 0; state <= WIN; end
                        else state <= RESULT;
                    end
                end
                T2: begin
                    d1 <= 6'b1100111; d2 <= 6'b0000010; // P2 G
                    d3 <= 6'b0000000; d4 <= 6'b1011111;
                    if (enter_rising) begin
                        calc_bulls_cows(secret1, SW, bulls, cows);
                        if (bulls == 4) begin flag_winner <= 1; state <= WIN; end
                        else state <= RESULT;
                    end
                end
                RESULT: begin
                    d1 <= bulls; d2 <= 6'b0011111; // X b
                    d3 <= 6'b0000000; d4 <= cows;  // X c
                    d5 <= 6'b0001101;
                    if (enter_rising) begin bulls <= 0; cows <= 0; state <= (flag_winner == 0) ? T2 : T1; end
                end
                WIN: begin
                    d1 <= 6'b0011111; d2 <= 6'b0000000; d3 <= 6'b1001111; // b E
                    if (flag_winner == 0) p1_win <= 1; else p2_win <= 1;
                    if (enter_rising) state <= S1;
                end
            endcase
        end
    end
endmodule
