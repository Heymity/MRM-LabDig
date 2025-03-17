module fluxo_dados (
	input				clock,
					
	input				zeraC,
	input				contaC,
	input				zeraS,
	input				contaS,
	input				zeraR,
	input				registraR,
		
	input	[3:0]		chaves,
	input				contaT,
	input				zeraT,
		
	input				zeraD,
	input				registraD,
	input				dificuldade,
					
	input				registraM,
	input				zeraM,
					
	input				contaTLeds,
	input				zeraTLeds,
	
	input				zeraSM,
	input				registraSM,
	input				memorySelect,
	
	input				display_refresh_clock,
	input				zera_display,
	input				show_display,
	
	output [3:0]	leds,
	
	output			timerLedsFim,
	output       	igual,
	output       	fimJ,
	output		  	fimS,
	output		  	fimT,
	output       	jogada_feita,
	
	output [7:0] 	matriz_r, matriz_g, matriz_b, matriz_col,
	
	
	output       	db_tem_jogada,
	output [3:0] 	db_contagem,
	output [3:0] 	db_seqCont,
	output [3:0] 	db_memoria,
	output [3:0] 	db_jogada
);

	wire [3:0] s_contador, s_registrador, s_rom, s_contadorS;
	wire WideOr0;
	
	assign WideOr0 = chaves[0] | chaves [1] | chaves [2] | chaves [3];
	assign db_tem_jogada = WideOr0;
	assign db_contagem = s_contador;
	assign db_seqCont = s_contadorS;
	assign db_memoria = s_rom;
	assign db_jogada = s_registrador;
	
	// JOGADA
	
	contador_163 contadorJ (
		.clock( clock ),
		.clr  ( ~zeraC ),
		.ld   ( 1'b1 ),
		.ent  ( 1'b1 ),
		.enp  ( contaC ),
		.D    ( 4'b0000 ),
		.Q    ( s_contador ),
		.rco  (  )
	);

	registrador_4 registradorJ (
		.clock ( clock ),
		.clear ( zeraR ),
		.enable( registraR ),
		.D     ( chaves ),
		.Q     ( s_registrador )
	);


	comparador_85 comparadorJ (
		.ALBi( 1'b0 ),
		.AGBi( 1'b0 ),
		.AEBi( 1'b1 ),
		.A   ( s_rom ),
		.B   ( s_registrador ),
		.ALBo( ),
		.AGBo( ),
		.AEBo( igual )
	);

	edge_detector detector (
		.clock( clock ),
		.reset( ~WideOr0 ),
		.sinal( WideOr0 ),
		.pulso( jogada_feita )
	);
	
	// SELETOR MEMORIA
	
	wire [3:0] s_rom0, s_rom1, memSel;
	
	registrador_4 registradorMemoria (
		.clock ( clock ),
		.clear ( zeraSM ),
		.enable( registraSM ),
		.D     ( { 3'b0, memorySelect }),
		.Q     ( memSel )
	);
	
	rom_16x4 memoria0 (
		.address ( s_contador ),
		.data_out( s_rom0 )
	);
	
	rom_16x4_v2 memoria1 (
		.address ( s_contador ),
		.data_out( s_rom1 )
	);
	
	mux2x1_n #(.BITS(4)) seletorMemoria (
		.D0	(s_rom0),
		.D1	(s_rom1),
		.SEL	(memSel[0]),
		.OUT	(s_rom)
	);
	
	
	// SEQUENCIA
	
	wire fim_jogo, meio_jogo;
	wire [3:0] dif;
	
	contador_m #(.M(16), .N(4)) contadorS (
		.clock		( clock ),
		.zera_as  ( zeraS ),
		.zera_s   ( 1'b0 ),
		.conta  	( contaS ),
		.Q    		( s_contadorS ),
		.fim  		( fim_jogo ),
		.meio 		( meio_jogo )
	);
	
	registrador_4 registradorDificuldade (
		.clock ( clock ),
		.clear ( zeraD ),
		.enable( registraD ),
		.D     ( { 3'b0, dificuldade }),
		.Q     ( dif )
	);
	
	mux2x1 mux (
		.D0	(meio_jogo),
		.D1	(fim_jogo),
		.SEL	(dif[0]),
		.OUT	(fimJ)
	);

	comparador_85 comparadorS (
		.ALBi( 1'b0 ),
		.AGBi( 1'b0 ),
		.AEBi( 1'b1 ),
		.A   ( s_contador ),
		.B   ( s_contadorS ),
		.ALBo( ),
		.AGBo( ),
		.AEBo( fimS )
	);
	
	// LEDS CONTROL
	
	wire timerLedsMeio;
	
	contador_m #(.M(1000), .N(12)) timer_leds (
		.clock(clock),
		.zera_as(zeraTLeds),
		.zera_s(1'b0),
		.conta(contaTLeds),
		.Q(),
		.fim(timerLedsFim),
		.meio(timerLedsMeio)
	); 
	
	registrador_4 registradorLeds (
		.clock ( clock ),
		.clear ( timerLedsMeio | zeraM),
		.enable( registraM ),
		.D     ( s_rom ),
		.Q     ( leds )
	);
	
	
	// TIMEOUT
	
	contador_m #(.M(5000), .N(13)) cont_timeout (
		.clock(clock),
		.zera_as(zeraT),
		.zera_s(1'b0),
		.conta(contaT),
		.Q(),
		.fim(fimT),
		.meio()
	);  
	
	
	
	// DISPLAY
	
	matrix_controller display_controller (
		.clock(clock), 
		.display_refresh_clock(display_refresh_clock), 
		.reset_display(zera_display), 
		.show_display(show_display), 
		.desce_jogada(1'b1),
	
		.pontos(6'b000000),
		.linhas_bloqueadas(3'b000),
		.prox_jogada(4'b0000),
	
		.matriz_col(matriz_col), 
		.matriz_r(matriz_r), 
		.matriz_g(matriz_g), 
		.matriz_b(matriz_b)

);
			
endmodule