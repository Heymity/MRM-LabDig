module MRMFD (
    input clock,
    input display_refresh_clock,
    input reset_display,
    input show_display,
    input desce_jogada,
    input gerarRand,
    input enableRProxJ,
    input clearRInputJ,
    input enableRInputJ,
    input enableContPontos,
    input muxJogada,
    input muxProxJogada,
    input RAMWrite,
    input compEnable,
    input resetContP,
    input contaP,
    input resetContJ,
    input contaJ,
    input acertou,
    input errou,
    input [3:0] jogada,
    output jogada_feita,
    output igual,
    output ContP_fim_antes,
    output ContP_fim_depois,
    output fimJogo,
    output [7:0] matriz_col,
    output [7:0] matriz_r,
    output [7:0] matriz_g,
    output [7:0] matriz_b
);

wire [7:0] matriz_col_wire;
wire [7:0] matriz_r_wire;
wire [7:0] matriz_g_wire;
wire [7:0] matriz_b_wire;
wire [5:0] pontos;
wire [2:0] linhas_bloq;
wire [3:0] randNum;
wire [3:0] jogadaAntes;
wire [3:0] jogadaDepois;
wire [3:0] jogadaAtual;
wire [3:0] RInput_Out;
wire [3:0] ProxJogada;
wire [1:0] seed;
wire WideOr0;

assign WideOr0 = jogada [0] | jogada [1] | jogada [2] | jogada [3];
assign matriz_col = matriz_col_wire;
assign matriz_r = matriz_r_wire;
assign matriz_g = matriz_g_wire;
assign matriz_b = matriz_b_wire;

//registrador_parametrizavel #(.M(2)) nivel REG (
//    .clock(),
//    .clear(),
//    .enable(),
//    .D(),
//    .Q()
//)

contador_m #(.M(4), .N(2)) ContRand (
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(1'b0),
    .conta(1'b1),
    .Q(seed),
    .fim(),
    .meio()
);

random_number Rand (
    .gerar(gerarRand),
    .seed(seed),
    .numero(randNum)
);

edge_detector Edge (
    .clock(clock),
    .reset(~WideOr0),
    .sinal(WideOr0),
    .pulso(jogada_feita)
);

registrador_parametrizavel input_jogada (
    .clock(clock),
    .clear(clearRInputJ),
    .enable(enableRInputJ),
    .D(jogada),
    .Q(RInput_Out)
);

mux2x1 MuxProxJogada (
    .D0(randNum),
    .D1(4'b0000),
    .SEL(muxJogada),
    .OUT(ProxJogada)
);

ram_8x4 RAM (
    .data_in(ProxJogada),
    .write(RAMWrite),
    .data_out1(jogadaDepois),
    .data_out2(jogadaAntes)
);

mux2x1 MuxJogada (
    .D0(jogadaDepois),
    .D1(jogadaAntes),
    .SEL(muxJogada),
    .OUT(jogadaAtual)
);

comparador_jogadas CompJ (
    .A(jogadaAtual),
    .B(RInput_Out),
    .enable(compEnable),
    .AEB(igual)
);

contador_periodo ContP (
    .clock(contaP),
    .zera_as(1'b0),
    .zera_s(resetContP),
    .conta(1'b1),
    .Q(),
    .fim_antes(ContP_fim_antes),
    .fim_depois(ContP_fim_depois)
);

contador_jogadas ContJ (
    .clock(clock),
    .rst(resetContJ),
    .conta(contaJ),
    .fim(fimJogo),
    .Q()
);

contador_pontos ContPontos (
	 .clk(clock),
    .acertou(acertou),
    .errou(errou),
    .enable(enableContPontos),
    .pontos(pontos),
    .linhas_bloq(linhas_bloq)
);

matrix_controller matrizC (
	.clock(clock),
    .display_refresh_clock(display_refresh_clock),
    .reset_display(reset_display),
    .show_display(show_display),
    .desce_jogada(desce_jogada),
    .pontos(pontos),
	.linhas_bloqueadas(linhas_bloq),
	.prox_jogada(ProxJogada),
	.matriz_col(matriz_col_wire),
    .matriz_r(matriz_r_wire),
    .matriz_g(matriz_g_wire),
    .matriz_b(matriz_b_wire)
);

endmodule