

`timescale 1ns/1ns

module circuito_exp6_acerto_tb;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
	reg        clock_in   = 1;
	reg        reset_in   = 0;
	reg        iniciar_in = 0;
	reg  [3:0] chaves_in  = 4'b0000;
	
	wire       ganhou_out;
	wire       perdeu_out  ;
	wire       pronto_out ;
	wire		  timeout_out;
	wire [3:0] leds_out   ;
	
	wire       db_igual_out      ;
	wire [6:0] db_contagem_out   ;
	wire [6:0] db_memoria_out    ;
	wire [6:0] db_estado_out     ;
	wire [6:0] db_jogadafeita_out;
	wire       db_clock_out      ;
	wire       db_iniciar_out    ;
	wire       db_tem_jogada_out ;
	wire [6:0] db_seqCont;
	wire		  db_mostra_leds;
	
	reg mem;
	reg dif;
	reg espera_leds=0;
	
	// Configuração do clock
	parameter clockPeriod = 1_000_000; // in ns, f=1KHz
	
	// Identificacao do caso de teste
	reg [31:0] caso = 0;
	
	// Gerador de clock
	always #((clockPeriod / 2)) clock_in = ~clock_in;
	
	// instanciacao do DUT (Device Under Test)
	circuito_exp6 dut (
		.clock				( clock_in    			),
		.reset				( reset_in    			),
		.jogar				( iniciar_in  			),
		.botoes				( chaves_in   			),
		.ganhou				( ganhou_out 			),
		.perdeu				( perdeu_out  			),
		.pronto				( pronto_out  			),
		.timeout				( timeout_out			),
		.leds					( leds_out    			),
		.dificuldade		( dif						),
		.memoria				( mem						),
		.db_igual       	( db_igual_out       ),
		.db_contagem    	( db_contagem_out    ),
		.db_memoria			( db_memoria_out     ),
		.db_estado      	( db_estado_out      ),
		.db_jogadafeita 	( db_jogadafeita_out ),
		.db_clock       	( db_clock_out       ),
		.db_iniciar     	( db_iniciar_out     ),    
		.db_tem_jogada  	( db_tem_jogada_out  ),
		.db_seqCont			( db_seqCont			),
		.db_mostra_leds	( db_mostra_leds		)
	);
	 
	reg [3:0] correctPlay [15:0];
	 
	integer i, j;
	 
    // geracao dos sinais de entrada (estimulos)
	initial begin
		correctPlay[0 ] = 4'b0001;
		correctPlay[1 ] = 4'b0010;
		correctPlay[2 ] = 4'b0100;
		correctPlay[3 ] = 4'b1000;
		correctPlay[4 ] = 4'b0100;
		correctPlay[5 ] = 4'b0010;
		correctPlay[6 ] = 4'b0001;
		correctPlay[7 ] = 4'b0001;
		correctPlay[8 ] = 4'b0010;
		correctPlay[9 ] = 4'b0010;
		correctPlay[10] = 4'b0100;
		correctPlay[11] = 4'b0100;
		correctPlay[12] = 4'b1000;
		correctPlay[13] = 4'b1000;
		correctPlay[14] = 4'b0001;
		correctPlay[15] = 4'b0100;
	 
		$dumpfile("circuito_exp6_acerto_tb.vcd");
		$dumpvars(0, circuito_exp6_acerto_tb);
		$display("Inicio da simulacao");

      // condicoes iniciais
      caso       = 0;
      clock_in   = 1;
      reset_in   = 0;
      iniciar_in = 0;
      chaves_in  = 4'b0000;
      #clockPeriod;


      // 1. resetar circuito
      caso = 1;
      // gera pulso de reset
      @(negedge clock_in);
      reset_in = 1;
		dif = 1;
		mem = 0;
      #(clockPeriod);
      reset_in = 0;
      // espera
      #(10*clockPeriod);

      // 2. iniciar=1 por 5 periodos de clock
      caso = 2;
      iniciar_in = 1;
      #(5*clockPeriod);
      iniciar_in = 0;
      // espera
      #(10*clockPeriod);

		
		// 3. Todas as jogadas corretas
		for (i = 0; i < 16; i=i+1) begin
			espera_leds = 1;
			@(negedge db_mostra_leds);
			#(10*clockPeriod);
			espera_leds = 0;
			
			for (j = 0; j <= i; j=j+1) begin
				caso = caso + 1;
				
				@(negedge clock_in);
				chaves_in = correctPlay[j];
				#(10*clockPeriod);
				chaves_in = 4'b0000;
				
				#(10*clockPeriod);
					
			end
		end
		
		#(4000*clockPeriod);
		#(4000*clockPeriod);

		
		correctPlay[0 ] = 4'b0001;
		correctPlay[1 ] = 4'b0010;
		correctPlay[2 ] = 4'b0100;
		correctPlay[3 ] = 4'b1000;
		correctPlay[4 ] = 4'b0001;
		correctPlay[5 ] = 4'b0010;
		correctPlay[6 ] = 4'b0100;
		correctPlay[7 ] = 4'b1000;
		correctPlay[8 ] = 4'b0001;
		correctPlay[9 ] = 4'b0010;
		correctPlay[10] = 4'b0100;
		correctPlay[11] = 4'b1000;
		correctPlay[12] = 4'b0001;
		correctPlay[13] = 4'b0010;
		correctPlay[14] = 4'b0100;
		correctPlay[15] = 4'b1000;
		
		// 1. resetar circuito
      caso = 1;
      // gera pulso de reset
      @(negedge clock_in);
      reset_in = 1;
		dif = 1;
		mem = 1;
      #(clockPeriod);
      reset_in = 0;
      // espera
      #(10*clockPeriod);

      // 2. iniciar=1 por 5 periodos de clock
      caso = 2;
      iniciar_in = 1;
      #(5*clockPeriod);
      iniciar_in = 0;
      // espera
      #(10*clockPeriod);

		
		// 3. Todas as jogadas corretas
		for (i = 0; i < 16; i=i+1) begin
			espera_leds = 1;
			@(negedge db_mostra_leds);
			#(10*clockPeriod);
			espera_leds = 0;
			
			for (j = 0; j <= i; j=j+1) begin
				caso = caso + 1;
				
				@(negedge clock_in);
				chaves_in = correctPlay[j];
				#(10*clockPeriod);
				chaves_in = 4'b0000;
				
				#(10*clockPeriod);
					
			end
		end
		
		#(1000*clockPeriod);
		
		#(1000*clockPeriod);
		
      // final dos casos de teste da simulacao
		caso = 9999;
		#100;
		$display("Fim da simulacao");
		$stop;
		$finish();
    end

endmodule
