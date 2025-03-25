//Comparador para as jogadas realizadas pelos jogadores. A saída AEB é verdadeira quando as jogadas são iguais e o 
//enable está ativo. A saída AEB é falsa quando as jogadas são diferentes ou o enable está desativado.

module comparador_jogadas(
input [3:0] A, B,
input enable,
output reg AEB
);

always @(A) begin
    if (enable) begin
        if (A == B) begin
            AEB <= 1;
        end
        else begin
            AEB <= 0;
        end
    end
    else begin
        AEB <= 0;
    end
end

endmodule