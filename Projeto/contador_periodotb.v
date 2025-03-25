`timescale 1ns/1ns

module contador_periodotb;
    reg clock;
    reg zera_as;
    reg zera_s;
    reg conta;
    wire [3:0] Q;
    wire fim_depois;
    wire fim_antes;

    contador_periodo #(.M(10), .N(4)) dut (
        .clock      ( clock      ),
        .zera_as    ( zera_as    ),
        .zera_s     ( zera_s     ),
        .conta      ( conta      ),
        .Q         ( Q         ),
        .fim_depois( fim_depois),
        .fim_antes ( fim_antes )
    );

    always #0.5 clock = ~clock;

    initial begin
        $monitor("Time: %0t | clock: %b | zera_as: %b | zera_s: %b | conta: %b | Q: %b | fim_depois: %b | fim_antes: %b", 
                 $time, clock, zera_as, zera_s, conta, Q, fim_depois, fim_antes);

        clock = 0;
        zera_as = 0;
        zera_s = 0;
        conta = 0;
        #1 zera_as = 1;
        #1 zera_as = 0;
        #1 zera_s = 1;
        #1 zera_s = 0; 
        #1 conta = 1;
        #20;
        conta = 0;
        #10;
        $finish;
    end
endmodule

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