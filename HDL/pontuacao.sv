module pontuacao(
    input clock,
    input reset,
    input p1vic,      
    input p2vic,    
    output reg game_over,  
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

            if (!game_over) begin // se nao acabou
                if (p1vic_pulse && p1pontos < 7) begin
                    p1pontos <= p1pontos + 1;
                    if (p1pontos == 6) game_over <= 1;  // 7º ponto
                end
                if (p2vic_pulse && p2pontos < 7) begin
                    p2pontos <= p2pontos + 1;
                    if (p2pontos == 6) game_over <= 1;  // 7º ponto
                end
            end 
              case (p1pontos)
                3'd0: LED[15:8] = 8'b00000000;
                3'd1: LED[15:8] = 8'b10000000;
                3'd2: LED[15:8] = 8'b11000000;
                3'd3: LED[15:8] = 8'b11100000;
                3'd4: LED[15:8] = 8'b11110000;
                3'd5: LED[15:8] = 8'b11111000;
                3'd6: LED[15:8] = 8'b11111100;
                3'd7: LED[15:8] = 8'b11111110;
                default: LED[15:8] = 8'b11111111;
            endcase

            case (p2pontos)
                3'd0: LED[7:0] = 8'b00000000;
                3'd1: LED[7:0] = 8'b00000001;
                3'd2: LED[7:0] = 8'b00000011;
                3'd3: LED[7:0] = 8'b00000111;
                3'd4: LED[7:0] = 8'b00001111;
                3'd5: LED[7:0] = 8'b00011111;
                3'd6: LED[7:0] = 8'b00111111;
                3'd7: LED[7:0] = 8'b01111111;
                default: LED[7:0] = 8'b11111111;
            endcase
        end
    end
endmodule
