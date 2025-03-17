module unidade_controle (
	input			clock,
	input			reset,
	input			iniciar,
	input			fimJ,
	input			fimS,
	input			jogada,
	input			timeout,
	input			igual,
	
	input			timerLedsFim,
	
	output reg	zeraSM,		
	output reg	registraSM,
	
	output reg	zeraD,
	output reg 	registraD,
	output reg	zeraS,	
	output reg	contaS,
	output reg	zeraC,
	output reg	contaC,
	output reg	zeraR,
	output reg	registraR,
	output reg	acertou,
	output reg	errou,
	output reg	outOfTime,
	output reg	pronto,
	output reg	contaT,
	output reg	zeraT,
	
	output reg	registraM,	
	output reg	zeraM,
	output reg	contaTLeds,	 
	output reg	zeraTLeds,
	
	
	output reg [3:0] db_estado
);

	// Define estados
	localparam inicial			= 4'h0;  
	localparam preparacao		= 4'h1;  
	localparam preparaSeq		= 4'h2;
	localparam carregaDado		= 4'h3; 
	localparam mostraDado		= 4'h4; 
	localparam proximoLeds		= 4'h5; 
	localparam preparaRodada	= 4'h6; 
	localparam espera				= 4'h7;  
	localparam registra			= 4'h8;  
	localparam comparacao		= 4'h9;  
	localparam proximo 			= 4'hB;  
	localparam proximaSeq		= 4'hC;
	localparam avancaSeq			= 4'hD;
	localparam fim_acertou		= 4'hA;  
	localparam fim_errou			= 4'hE;  
	localparam fim_timeout		= 4'hF;  
	
	
	// Variaveis de estado
	reg [3:0] Eatual, Eprox;
	
	// Memoria de estado
	always @(posedge clock or posedge reset) begin
		if (reset)
			Eatual <= inicial;
		else
			Eatual <= Eprox;
	end
	
	// Logica de proximo estado
	always @* begin
		case (Eatual)
			inicial:			Eprox = iniciar 	? preparacao : inicial;
			preparacao:		Eprox = preparaSeq; 
			preparaSeq:		Eprox = carregaDado;
			
			carregaDado:	Eprox = mostraDado;
			mostraDado:		Eprox = timerLedsFim ? (fimS ? preparaRodada : proximoLeds) : mostraDado;
			proximoLeds:	Eprox = carregaDado;
			preparaRodada:	Eprox = espera;
			
			espera:     	Eprox = timeout 	? fim_timeout : 
											jogada  	? registra : espera;
			registra:   	Eprox = comparacao;
			comparacao: 	Eprox = igual 		? (fimS ? proximaSeq : proximo) : fim_errou;
			proximo:    	Eprox = espera;
			proximaSeq:		Eprox = fimJ 		? fim_acertou : avancaSeq;
			avancaSeq:	 	Eprox = preparaSeq;
			fim_acertou: 	Eprox = iniciar 	? preparacao : fim_acertou;
			fim_errou:   	Eprox = iniciar 	? preparacao : fim_errou;
			fim_timeout: 	Eprox = iniciar 	? preparacao : fim_timeout;
			default:     	Eprox = inicial;
		endcase
	end
	
	// Logica de saida (maquina Moore)
	always @* begin
		zeraC			= (Eatual == preparacao || Eatual == preparaSeq || Eatual == preparaRodada)	? 1'b1 : 1'b0;
		zeraR			= (Eatual == inicial)		? 1'b1 : 1'b0;
		registraR	= (Eatual == registra)		? 1'b1 : 1'b0;
		contaC		= (Eatual == proximo || Eatual == proximoLeds)		? 1'b1 : 1'b0;
		acertou		= (Eatual == fim_acertou)	? 1'b1 : 1'b0;
		errou			= (Eatual == fim_errou)		? 1'b1 : 1'b0;
		pronto		= (Eatual == fim_acertou || Eatual == fim_errou || Eatual == fim_timeout) ? 1'b1 : 1'b0;
		contaT		= (Eatual == espera)			? 1'b1 : 1'b0;
		zeraT			= (Eatual == preparacao || Eatual == registra) ? 1'b1 : 1'b0;
		outOfTime	= (Eatual == fim_timeout)	? 1'b1 : 1'b0;
		zeraS			= (Eatual == preparacao)	? 1'b1 : 1'b0;
		contaS		= (Eatual == avancaSeq)		? 1'b1 : 1'b0;
		zeraD			= (Eatual == inicial) 		? 1'b1 : 1'b0;
		registraD	= (Eatual == preparacao)	? 1'b1 : 1'b0;
		
		registraM	= (Eatual == carregaDado) 	? 1'b1 : 1'b0;
		zeraM			= (Eatual == preparaSeq) 	? 1'b1 : 1'b0;
		contaTLeds	= (Eatual == mostraDado) 	? 1'b1 : 1'b0;
		zeraTLeds	= (Eatual == carregaDado) 	? 1'b1 : 1'b0;
		zeraSM		= (Eatual == inicial)		? 1'b1 : 1'b0;
		registraSM	= (Eatual == preparacao) 	? 1'b1 : 1'b0;
		
		  
		// Saida de depuracao (estado)
		case (Eatual)
			inicial:				db_estado = inicial;  
			preparacao:			db_estado = preparacao;  
			preparaSeq:			db_estado = preparaSeq;  
			carregaDado:		db_estado = carregaDado;  
			mostraDado:			db_estado = mostraDado;  
			proximoLeds:		db_estado = proximoLeds;  
			preparaRodada:		db_estado = preparaRodada;  
			espera:				db_estado = espera;  
			registra:			db_estado = registra;  
			comparacao:			db_estado = comparacao;
			proximo: 			db_estado = proximo;
			proximaSeq:			db_estado = proximaSeq;
			avancaSeq:			db_estado = avancaSeq; 
			fim_acertou:		db_estado = fim_acertou; 
			fim_errou:			db_estado = fim_errou; 
			fim_timeout:		db_estado = fim_timeout; 
			

			default:			db_estado = 4'b0000;  // 0 (erro)
		endcase
	end
	 
endmodule