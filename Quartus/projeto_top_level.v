module projeto_top_level (
	input        clock, reset, jogar, dificuldade, memoria,
	input  [3:0] botoes,
	
	input	show_display, zera_display, display_refresh_clock,
	
	output       ganhou, perdeu, pronto, timeout,
	output [3:0] leds,
	

	output [7:0] matriz_r, matriz_g, matriz_b, matriz_col,
	 
	// Depuracao
	output [6:0] db_contagem, db_memoria, db_estado, db_jogadafeita, db_seqCont,  				// Display 7 segmentos
	output       db_igual, db_clock, db_iniciar, db_tem_jogada, db_mostra_leds
);


	
	


	wire s_zeraC;
	wire s_contaC;
	
	wire s_zeraR;
	wire s_registraR;
	
	wire s_zeraS;
	wire s_contaS; 
	
	wire zeraD;
	wire registraD;
	
	wire s_fimS;
	wire s_fimJ;
	wire s_timeout;
	
	wire s_contaT;
	wire s_zeraT;
	
	wire s_igual;
	wire s_jogada;
	
	wire s_registraM;
	wire s_zeraM;
		
	wire s_contaTLeds;
	wire s_zeraTLeds;
	wire s_timerLedsFim;
	
	
	wire [3:0] db_contagem_hexa;
	wire [3:0] db_seqCont_hexa;
	wire [3:0] db_memoria_hexa;
	wire [3:0] db_jogada_hexa;
	wire [3:0] db_estado_hexa;
	
	assign db_iniciar = jogar;
	assign db_clock = clock;
	assign db_igual = s_igual;
	assign db_mostra_leds = db_estado_hexa == 4'h3 || db_estado_hexa == 4'h4 || db_estado_hexa == 4'h5;

	
	fluxo_dados FD (
		.clock				( clock ),
		.zeraC            ( s_zeraC ),
		.contaC           ( s_contaC ),
		
		.zeraR            ( s_zeraR ),
		.registraR        ( s_registraR ),
		
		.chaves           ( botoes ),
		.igual            ( s_igual ),
		.jogada_feita     ( s_jogada ),
		
		.contaT			   ( s_contaT ),
		.zeraT				( s_zeraT ),
		.fimT					( s_timeout ),
		
		.zeraS				( s_zeraS ),
		.contaS				( s_contaS ),
		.fimS					( s_fimS ),
		.fimJ             ( s_fimJ ),
		
		.leds					( leds ),
		
		.zeraD				( zeraD ),
		.registraD			( registraD ),
		.dificuldade		( dificuldade ),
		
		.registraM			( s_registraM ),
		.zeraM				( s_zeraM ),
		
		.contaTLeds			( s_contaTLeds ),
		.zeraTLeds			( s_zeraTLeds ),
		.timerLedsFim		( s_timerLedsFim ),
	
		.zeraSM				( s_zeraSM ),
		.registraSM			( s_registraSM ),
		.memorySelect		( memoria ),
		
		
		.db_tem_jogada    ( db_tem_jogada ),
		.db_contagem      ( db_contagem_hexa ),
		.db_seqCont  		( db_seqCont_hexa ),
		.db_memoria       ( db_memoria_hexa ),
		.db_jogada        ( db_jogada_hexa ),
		
		
		.display_refresh_clock(display_refresh_clock),
		.zera_display(zera_display),
		.show_display(show_display),
		
		
		.matriz_r(matriz_r),
		.matriz_g(matriz_g),
		.matriz_b(matriz_b),
		.matriz_col(matriz_col)
	);
	

	unidade_controle UC (
		.clock         	( clock ),
		.reset         	( reset ),
		.iniciar				( jogar ),
		
		.fimJ					( s_fimJ ),
		.fimS					( s_fimS ),
		
		.zeraS				( s_zeraS ),
		.contaS				( s_contaS ),
		
		.zeraC       	   ( s_zeraC ),
		.contaC				( s_contaC ),
		
		.zeraR       	   ( s_zeraR ),
		.registraR			( s_registraR ),
		
		.zeraD				( zeraD ),
		.registraD			( registraD ),
		
		.registraM			( s_registraM ),
		.zeraM				( s_zeraM ),
		
		.zeraSM				( s_zeraSM ),
		.registraSM			( s_registraSM ),
		
		.contaTLeds			( s_contaTLeds ),
		.zeraTLeds			( s_zeraTLeds ),
		.timerLedsFim		( s_timerLedsFim ),
		
		.jogada      	   ( s_jogada ),
		.igual       	   ( s_igual ),

		
		.acertou       	( ganhou ),
		.errou				( perdeu ),
		.pronto        	( pronto ),
		.db_estado      	( db_estado_hexa ),
		.timeout				( s_timeout ),
		.contaT				( s_contaT ),
		.zeraT				( s_zeraT ),
		.outOfTime			( timeout )
	);

	hexa7seg display_contagem (
		.hexa    ( db_contagem_hexa ),
		.display ( db_contagem )
	);
	 
	hexa7seg display_seqCont(
		.hexa    ( db_seqCont_hexa ),
		.display ( db_seqCont )
	);

	hexa7seg display_memoria (
		.hexa    ( db_memoria_hexa ),
		.display ( db_memoria )
	);

	hexa7seg display_jogada (
		.hexa    ( db_jogada_hexa ),
		.display ( db_jogadafeita )
	);
	
	hexa7seg display_estado (
		.hexa    ( db_estado_hexa ),
		.display ( db_estado )
	);
	
endmodule
