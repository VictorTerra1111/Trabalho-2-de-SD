module BullsCows(
    input [15:0] SW,
    input clock,
    input reset,
    input ssl,

    output reg [5:0] d1, d2, d3, d4, d5, d6, d7, d8,
    output reg p1_win,
    output reg p2_win
);
    typedef enum logic [2:0] {S1, S2, T1, T2, RESULT, WIN} state_t; 
    state_t state; // possiveis estados

    reg [15:0] secret1, secret2; // codigos a serem guardados
    integer bulls_int, cows_int; // inteiros para contagem de bois e vacas
    reg flag_winner;  // 0: p1, 1: p2

    wire enter_rising; // para detector de borda

    edge_detector_s ed (
        .clock(clock),
        .reset(reset),
        .din(ssl),
        .rising(enter_rising)
    );

    function automatic logic tem_repetidos(input [15:0] sw_in);
        reg [3:0] d [3:0];
        integer i, j;

        begin
            // quebra os 16 bits em 4
            for (i = 0; i < 4; i++) begin
                d[i] = sw_in[i*4 +: 4]; // part-select 
            end
            for (i = 0; i < 4; i++) begin // compara todos os numeros
                for (j = i + 1; j < 4; j++) begin
                    if (d[i] == d[j]) begin
                        return 1;  // tem repetido
                    end
                end
            end
            return 0;  // tudo certo
        end
    endfunction
        
    // funcao para converter valor de bois e vacas para display
    function automatic [5:0] to_disp6(input integer value);
        if (value >= 0 && value <= 9)
            to_disp6 = {1'b0, value[3:0], 1'b0};  // 0, valor, 0
        else
            to_disp6 = 6'b111111; // -
    endfunction

    // calculo de boi e vaca
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
            secret1 <= 0; 
            secret2 <= 0;
            bulls_int <= 0; 
            cows_int <= 0;
            p1_win <= 0; 
            p2_win <= 0;
            flag_winner <= 0;

            d1 <= 6'b111111;  // -
            d2 <= 6'b111111;  // -
            d3 <= 6'b111111;  // -
            d4 <= 6'b111111;  // -
            d5 <= 6'b111111;  // -
            d6 <= 6'b111111;  // -
            d7 <= 6'b111111;  // -
            d8 <= 6'b111111;  // -

        end else begin
            case (state)
                S1: begin // set up de p1
                    d1 <= 6'b011110; // U
                    d2 <= 6'b011010; // S
                    d3 <= 6'b111111; // -
                    d4 <= 6'b000010; // 1
                    d5 <= 6'b010100; // P
                    d6 <= 6'b111111; // -
                    d7 <= 6'b111111; // -
                    d8 <= 6'b111111; // -
                    if (enter_rising) begin
                        if (!tem_repetidos(SW)) begin
                            secret1 <= SW;
                            state <= S2;
                        end
                    end
                end
                S2: begin // set up de p2
                    d1 <= 6'b011110; // U
                    d2 <= 6'b011010; // S
                    d3 <= 6'b111111; // -
                    d4 <= 6'b000100; // 2
                    d5 <= 6'b010100; // P
                    d6 <= 6'b111111; // -
                    d7 <= 6'b111111; // -
                    d8 <= 6'b111111; // -
                    if (enter_rising) begin
                        if (!tem_repetidos(SW)) begin
                            secret2 <= SW;
                            state <= T1;
                        end
                    end
                end
                T1: begin // vez de p1
                    d1 <= 6'b001100;  // G (6)
                    d2 <= 6'b111111; // -
                    d3 <= 6'b000010;  // 1
                    d4 <= 6'b010100;  // P
                    d5 <= 6'b111111; // -
                    d6 <= 6'b111111; // -
                    d7 <= 6'b111111; // -
                    d8 <= 6'b111111; // -
                    if (enter_rising) begin // se confirma
                        calc_bulls_cows(secret2, SW, bulls_int, cows_int);
                        if (bulls_int == 4) begin 
                            flag_winner <= 0; state <= WIN;  // se tem 4 bulls
                        end
                        else state <= RESULT;
                    end
                end
                T2: begin // vez de p2
                    d1 <= 6'b001100;  // G (6)
                    d2 <= 6'b111111; // -
                    d3 <= 6'b000100;  // 1
                    d4 <= 6'b010100;  // P
                    d5 <= 6'b111111; // -
                    d6 <= 6'b111111; // -
                    d7 <= 6'b111111; // -
                    d8 <= 6'b111111; // -
                    if (enter_rising) begin
                        calc_bulls_cows(secret1, SW, bulls_int, cows_int);
                        if (bulls_int == 4) begin 
                            flag_winner <= 1; state <= WIN;  // se tem 4 bulls
                        end else state <= RESULT;
                    end
                end
                RESULT: begin // mostra resultado do chute
                    d1 <= 6'b011000;           // c (cows)
                    d2 <= to_disp6(cows_int);  // numero de vacas
                    d3 <= 6'b111111;           // -
                    d4 <= 6'b010110;           // b (bulls)
                    d5 <= to_disp6(bulls_int); // numero de touros
                    d6 <= 6'b111111;           // -
                    d7 <= 6'b111111;           // -
                    d8 <= 6'b111111;           // -
                    if (enter_rising) begin // se confirma, reseta contagem de bois e vacas
                        bulls_int <= 0;
                        cows_int <= 0;
                        state <= (flag_winner == 0) ? T2 : T1;
                    end
                end
                WIN: begin // ganhou
                    d1 <= 6'b011100; // E  
                    d2 <= 6'b111111; // -
                    d3 <= 6'b010110; // B (bull's eye)
                    d4 <= 6'b111111; // -
                    d5 <= 6'b111111; // -
                    d6 <= 6'b111111; // -
                    d7 <= 6'b111111; // -
                    d8 <= 6'b111111; // -
                    if (flag_winner == 0) p1_win <= 1; // se p1 ganhou
                    else p2_win <= 1; // se p2 ganhou
                    if (enter_rising) state <= S1; // se confirma, recomeca
                end
            endcase
        end
    end
endmodule
