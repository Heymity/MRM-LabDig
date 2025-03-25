//Contador para o período qual o jogador deve realizar uma jogada. A saída fim_antes é ativada quando o período para realizar
//uma jogada antes da atualização do display termina. A saída fim_depois é ativada quando o período para realizar uma jogada
//após a atualização do display termina.

module contador_periodo #(parameter M=100, N=7)
  (
   input  wire          clock,
   input  wire          zera_as,
   input  wire          zera_s,
   input  wire          conta,
   output reg  [N-1:0]  Q,
   output reg           fim_depois,
   output reg           fim_antes    
  );

  always @(posedge clock or posedge zera_as) begin
    if (zera_as) begin
      Q <= 0;
    end else if (clock) begin
      if (zera_s) begin
        Q <= 0;
      end else if (conta) begin
        if (Q == M-1) begin
          Q <= 0;
        end else begin
          Q <= Q + 1'b1;
        end
      end
    end
  end

  // Saidas
  always @ (Q)
      if (Q == M-1)   fim_depois = 1;
      else            fim_depois = 0;

  always @ (Q)
      if (Q == M/4-1) fim_antes = 1;
      else            fim_antes = 0;

endmodule