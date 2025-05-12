module pontuacao(
    input clock,
    input reset,
    input p1vic,      
    input p2vic,      
    output reg [15:0] LED
);

    reg [2:0] p1pontos;
    reg [2:0] p2pontos;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            p1pontos <= 0;
            p2pontos <= 0;
            LED <= 16'b0;
        end else begin
            if (p1vic && p1pontos < 7) begin
                LED[15 - p1pontos] <= 1'b1;  // esquerda pra direita p1
                p1pontos <= p1pontos + 1;
            end
            if (p2vic && p2pontos < 7) begin
                LED[p2pontos] <= 1'b1;       // direita pra esquerda p2
                p2pontos <= p2pontos + 1;
            end
        end
    end

endmodule
