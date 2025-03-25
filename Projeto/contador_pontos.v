//Contador para os pontos. Se acertar, a pontuação sobe em 1. Se errar, ela desce em 1. Imediatamente ao receber o sinal de
//posedge de acertou ou errou, o contador verifica se o enable está ativo. Se sim, ele verifica se acertou ou errou e incrementa
//ou decrementa a pontuação. O contador também verifica a pontuação para saber quantas linhas de bloqueio devem ser ativadas.
//As condições para ativar linhas de bloqueio são os limites de pontuação respectivos a cada bloqueio. Ou seja, para a primeira
//linha esse limite é entre 4 e 7. Então, se chegar em 4 na pontuação, a primeira linha de bloqueio é ativada. 
//Se cair de 8 para 7, a segunda linha de bloqueio é desativada e apenas a primeira passa a ser ativa, e assim por diante.

module contador_pontos (
	 input clk,
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

always @ (posedge clk) begin
    if (enable) begin
        if (acertou) begin
            if (pontos < 6'd32) begin
                pontos <= pontos + 1'b1;
            end
        end else if (errou) begin
            if (pontos > 0) begin
                pontos <= pontos - 1'b1;
            end
        end
    end
end

always @ (pontos) begin
    if (pontos >= 6'd0 && pontos <= 6'd3) begin
        linhas_bloq = 3'd0;
    end else if (pontos >= 6'd4 && pontos <= 6'd7) begin
        linhas_bloq = 3'd1;
    end else if (pontos >= 6'd8 && pontos <= 6'd11) begin
        linhas_bloq = 3'd2;
    end else if (pontos >= 6'd12 && pontos <= 6'd15) begin
        linhas_bloq = 3'd3;
    end else if (pontos >= 6'd16 && pontos <= 6'd19) begin
        linhas_bloq = 3'd4;
    end else if (pontos >= 6'd20 && pontos <= 6'd23) begin
        linhas_bloq = 3'd5;
    end else if (pontos >= 6'd24 && pontos <= 6'd27) begin
        linhas_bloq = 3'd6;
    end else if (pontos >= 6'd28 && pontos <= 6'd32) begin
        linhas_bloq = 3'd7;
    end else begin
		  linhas_bloq = 3'd0;
	 end
end

endmodule