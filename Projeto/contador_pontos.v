//Contador para os pontos. Se acertar, a pontuação sobe em 1. Se errar, ela desce em 1. Imediatamente ao receber o sinal de
//posedge de acertou ou errou, o contador verifica se o enable está ativo. Se sim, ele verifica se acertou ou errou e incrementa
//ou decrementa a pontuação. O contador também verifica a pontuação para saber quantas linhas de bloqueio devem ser ativadas.
//As condições para ativar linhas de bloqueio são os limites de pontuação respectivos a cada bloqueio. Ou seja, para a primeira
//linha esse limite é entre 4 e 7. Então, se chegar em 4 na pontuação, a primeira linha de bloqueio é ativada. 
//Se cair de 8 para 7, a segunda linha de bloqueio é desativada e apenas a primeira passa a ser ativa. E assim por diante.

module contador_pontos (
    input acertou,
    input errou,
    input enable,
    output reg [5:0] pontos,
    output reg [2:0] linhas_bloq
);

initial begin
    pontos = 0;
    linhas_bloq = 0;
end

always @ (posedge acertou or posedge errou) begin
    if (enable) begin
        if (acertou) begin
            if (pontos == 32) begin
                pontos = 32;
            end else begin
                pontos = pontos + 1;
            end
        end else if (errou) begin
            if (pontos == 0) begin
                pontos = 0;
        end else
            pontos = pontos - 1;
        end
    end
end

always @ (pontos) begin
    if (pontos == 0) begin
        linhas_bloq = 0;
    end else if (pontos == 4 || pontos == 7) begin
        linhas_bloq = 1;
    end else if (pontos == 8 || pontos == 11) begin
        linhas_bloq = 2;
    end else if (pontos == 12 || pontos == 15) begin
        linhas_bloq = 3;
    end else if (pontos == 16 || pontos == 19) begin
        linhas_bloq = 4;
    end else if (pontos == 20 || pontos == 23) begin
        linhas_bloq = 5;
    end else if (pontos == 24 || pontos == 27) begin
        linhas_bloq = 6;
    end else if (pontos == 28) begin
        linhas_bloq = 7;
    end
end

endmodule