`timescale 1ns/1ns

module random_number_with_counter_tb;

    reg clock;
    reg gerar;
    reg zera_as;
    reg zera_s;
    reg conta;
    wire [1:0] seed;
    wire [3:0] numero;

    contador_m #(.M(4), .N(2)) contador (
        .clock(clock),
        .zera_as(zera_as),
        .zera_s(zera_s),
        .conta(conta),
        .Q(seed),
        .fim(),
        .meio()
    );

    random_number random_gen (
        .gerar(gerar),
        .seed(seed),
        .numero(numero)
    );

    always #0.5 clock = ~clock;

    initial begin
        $monitor("Time: %0t | clock: %b | gerar: %b | seed: %b | numero: %b", 
                 $time, clock, gerar, seed, numero);

        clock = 0;
        gerar = 0;
        zera_as = 0;
        zera_s = 0;
        conta = 0;

        #1 zera_as = 1;
        #1 zera_as = 0;
        #1 gerar = 1;
        #1 conta = 1;
        #1 gerar = 0;
        #1 gerar = 1;
        #1 gerar = 0;
        #1 gerar = 1;
        #1 gerar = 0;
        #1 gerar = 1;
        #1 gerar = 0;
        #5 $finish;
    end

endmodule

module random_number (
    input gerar,
    input reg [1:0] seed,
    output reg [3:0] numero
);

always @(posedge gerar) begin
    case (seed)
        2'b00: numero <= 4'b1000;
        2'b01: numero <= 4'b0100;
        2'b10: numero <= 4'b0010;
        2'b11: numero <= 4'b0001;
        default: numero <= 4'b0000;
    endcase
end

endmodule

module contador_m #(parameter M=100, N=7)
  (
   input  wire          clock,
   input  wire          zera_as,
   input  wire          zera_s,
   input  wire          conta,
   output reg  [N-1:0]  Q,
   output reg           fim,
   output reg           meio    
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

  always @ (Q)
      if (Q == M-1)   fim = 1;
      else            fim = 0;

  always @ (Q)
      if (Q == M/2-1) meio = 1;
      else            meio = 0;

endmodule
