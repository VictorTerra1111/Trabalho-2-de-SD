module pontuacao(
    input clock,
    input reset,
    input p1vic,      
    input p2vic,      
    output [15:0] LED
);

    reg [3:0] p1pontos;
    reg [3:0] p2pontos;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            p1pontos <= 0;
            p2pontos <= 0;
            LED <= 16'b0;
        end else begin
            if (p1vic && p1pontos < 8) begin
                LED[p1pontos] <= 1'b1;  // vai acendendo da esquerda
                p1pontos <= p1pontos + 1;
            end
            if (p2vic && p2pontos < 8) begin
                LED[15 - p2pontos] <= 1'b1;  // vai acendendo da direita
                p2pontos <= p2pontos + 1;
            end
        end
    end

endmodule
