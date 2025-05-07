/*
        TEM QUE ALTERAR QUANDO ENVIA DIG PRA ENVIAR POS TAMBÉM
   
    S1 = secret 1 (stores player 1 secret code). 
        inputs: 
            4 number code.
            push button enter.
        if there is any equal digits, comes back;
        else goes to S2;

    S2 = secret 2 (stores player 2 secret code).
        inputs: 
            4 number code.
            push button enter.
        if there is any equal digits, come back;
        else goes to T1;

    T1 = try 1 (player 1 tries to get the secret 2 right).
        inputs:
            4 number code.
            push button enter.
        if new code is equal to secret 2, goes to WIN;
        else goes to T2;

    T2 = try 2 (player 2 tries to get the secret 1 right).
        inputs:
            4 number code.
            push button enter.
        if new code is equal to secret 1, goes to WIN;
        else goes to T1;

    WIN = when a player gets the other player's code right.
        increment points
        reset everything
*/

module BullsCows(
    input [15:0] code,
    input clock,
    input reset,
    input enter_button,

    output [5:0]d1, d2, d3, d4, d5, d6, d7, d8
);
    typedef enum logic [1:0] {S1, S2, T1, T2, WIN} states_t;
    states_t states;

    reg [15:0] secret1, secret2, try;
    // registrador de rodadas e vitorias também
    reg counter, bulls, cows; // contador pra verificar o segredo
    reg p1_points, p2_points;
    reg flag_winner; // 0: p1 wins  1: p2 wins

    always_ff @(posedge clock) begin
        if (reset) begin
            states <= S1;
            secret1 <= 16'b0;
            secret2 <= 16'b0;
            try <= 16'b0;
            counter <= 0;
            pos <= 7;
        end else begin
            /* 
            começa testando se o codigo tem algum digito repetido, se tiver vai pra erro
            se nao tiver nenhum repetido, pode usar tranquilo
            ^^^ desse jeito nao precisa testar toda vez em cada estado

            pra testar se existe um numero que repete:
            for(counter; counter < 16; counter <= counter + 1) begin // verifica se entrada eh ok
                guarda valor atual em um reg;
                if(valor repetir) begin
                    states <= ERROR;
                    break;
                end // se nao, nao faz nada
            end
            */

            case (states)
                S1: begin
                    dig <= 6'b001010; // P na posicao 7
                    dig <= 6'b000001; // 1 na posicao 6
                    dig <= 6'd20; // nada na posicao 5
                    dig <= 6'b1011; // S na posicao 4
                    dig <= 6'b1100; // U na posicao 3
                    secret1 <= code;
                    states <= S2;
                end
                S2: begin
                    dig <= 6'b1010; // P na posicao 7
                    dig <= 6'b0010; // 2 na posicao 6
                    dig <= 6'd20; // nada na posicao 5
                    dig <= 6'b1011; // S na posicao 4
                    dig <= 6'b1100; // U na posicao 3
                    secret2 <= code;
                    states <= T1;
                end
                T1: begin
                    dig <= 6'b1010; // P na posicao 7
                    dig <= 6'b0001; // 1 na posicao 6
                    dig <= 6'd20; // nada na posicao 5
                    dig <= 6'b10001; // G na posicao 4
                    try <= code;
                    for(counter; counter < 16; counter <= counter + 1) begin
                        if(try tem algum numero igual a code) begin
                            if(counter for o mesmo) begin
                                bulls <= bulls + 1;
                            end else begin
                                cows <= cows + 1;
                            end
                        end
                    end 
                    if(bulls == 4) begin
                        states <= WIN; // se todos os numeros estiver certos 
                        flag_winner <= 0;
                    end else begin // se errou
                        states <= T2;
                    end
                end     
                T2: begin // mesma logica da pra fazer ate uma task pra nao repetir codigo
                    dig <= 6'b001010; // P na posicao 7
                    dig <= 6'b000010; // 2 na posicao 6
                    dig <= 6'd20; // nada na posicao 5
                    dig <= 6'b010001; // G na posicao 4
                    try <= code;
                    for(counter; counter < 16; counter <= counter + 1) begin
                        if(try tem algum numero igual a code) begin
                            if(counter for o mesmo) begin
                                bulls <= bulls + 1;
                            end else begin
                                cows <= cows + 1;
                            end
                        end
                    end 
                    if(bulls == 4) begin
                        states <= WIN; // se todos os numeros estiver certos 
                        flag_winner <= 1;
                    end else begin // se errou
                        states <= T1;
                    end
                end 
                WIN: begin
                    dig <= 6'b001111; // B
                    dig <= 6'b001101 // E
                    if (flag_winner) begin
                        p2_points <= p2_points + 1;
                    end else begin
                        p1_points <= p1_points + 1;
                    end
                end 

                default: states <= S1;
            endcase
        end
    end
endmodule
