module pontuacao(
    input clock,
    input reset,
    input p1vic,      
    input p2vic,    
    output game_over,  
    output reg [15:0] LED
);

    reg [2:0] p1pontos, p2pontos;
    reg p1wins_r, p2wins_r; 
    wire p1vic_pulse, p2vic_pulse;

    assign p1vic_pulse = p1vic & ~p1wins_r; // mesmo funcionamento do edge_detector_s
    assign p2vic_pulse = p2vic & ~p2wins_r;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            p1pontos <= 0;
            p2pontos <= 0;
            game_over <= 0;
            p1wins_r <= 0;
            p2wins_r <= 0;
            
            LED <= 16'b0;
        end else begin
            p1wins_r <= p1vic;
            p2wins_r <= p2vic;

            if (!game_over) begin // se nao eh acabou
                if (p1vic_pulse && p1pontos < 7) begin
                    LED[15 - p1pontos] <= 1'b1;
                    p1pontos <= p1pontos + 1;
                    if (p1pontos == 6) game_over <= 1;  // 7º ponto
                end
                if (p2vic_pulse && p2pontos < 7) begin
                    LED[p2pontos] <= 1'b1;
                    p2pontos <= p2pontos + 1;
                    if (p2pontos == 6) game_over <= 1;  // 7º ponto
                end
            end
        end
    end
endmodule
