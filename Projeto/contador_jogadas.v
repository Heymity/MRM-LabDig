//Contador para o número de jogadas realizadas. A saída fim é ativada quando o número de jogadas atinge o valor M, que é
//a última jogada do jogo.

module contador_jogadas #(parameter M=32, N=6)
(
    input  wire          clock,
    input  wire          rst,
    input  wire          conta,
    output reg  [N-1:0]  Q,
    output reg           fim
    );

    always @(posedge clock or posedge rst) begin
        if (rst) begin
            Q <= 0;
        end else if (clock) begin
            if (conta) begin
                if (Q == M) begin
                    Q <= 0;
                end else begin
                    Q <= Q + 1'b1;
                end
            end
        end
    end

    always @ (Q)
        if (Q == M)   fim = 1;
        else          fim = 0;

endmodule
