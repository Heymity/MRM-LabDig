module matrix_controller (
	input clock, display_refresh_clock, reset_display, show_display, desce_jogada,
	
	input [5:0] pontos,
	input [2:0] linhas_bloqueadas,
	input	[3:0] prox_jogada,
	
	output reg [7:0] matriz_col, matriz_r, matriz_g, matriz_b

);

	//  LINHAS					COLUNA RGB	**ATIVO BAIXO**
	reg [7:0] display_buffer [7:0][2:0];
	
	reg [7:0] jogadas [3:0];
	
	
	wire [7:0] line_block_mask;
	
	assign line_block_mask = ~(8'b11111111 >> linhas_bloqueadas);
	
	always @(posedge clock) begin
		if (reset_display) begin
			jogadas[0] <= 8'b11111111;
			jogadas[1] <= 8'b11111111;
			jogadas[2] <= 8'b11111111;
			jogadas[3] <= 8'b11111111;
			
			display_buffer[0][0] <= 8'b11111111;
			display_buffer[0][1] <= 8'b11111111;
			display_buffer[0][2] <= 8'b11111111;
			
			display_buffer[1][0] <= 8'b11111111;
			display_buffer[1][1] <= 8'b11111111;
			display_buffer[1][2] <= 8'b11111111;
			
			display_buffer[2][0] <= 8'b11111111;
			display_buffer[2][1] <= 8'b11111111;
			display_buffer[2][2] <= 8'b11111111;
			
			display_buffer[3][0] <= 8'b11111111;
			display_buffer[3][1] <= 8'b11111111;
			display_buffer[3][2] <= 8'b11111111;
			
			display_buffer[4][0] <= 8'b11111111;
			display_buffer[4][1] <= 8'b11111111;
			display_buffer[4][2] <= 8'b11111111;
			
			display_buffer[5][0] <= 8'b11111111;
			display_buffer[5][1] <= 8'b11111111;
			display_buffer[5][2] <= 8'b11111111;
			
			display_buffer[6][0] <= 8'b11111111;
			display_buffer[6][1] <= 8'b11111111;
			display_buffer[6][2] <= 8'b11111111;
			
			display_buffer[7][0] <= 8'b11111111;
			display_buffer[7][1] <= 8'b11111111;
			display_buffer[7][2] <= 8'b11111111;
		end
		else begin
			
			if (desce_jogada) begin
				jogadas[0] <= {jogadas[0][6:0], ~prox_jogada[0]};
				jogadas[1] <= {jogadas[1][6:0], ~prox_jogada[1]};
				jogadas[2] <= {jogadas[2][6:0], ~prox_jogada[2]};
				jogadas[3] <= {jogadas[3][6:0], ~prox_jogada[3]};
			end
			
			display_buffer[2][0] <= jogadas[0] | line_block_mask;
			display_buffer[2][1] <= 8'b11111111 & (~line_block_mask);
			display_buffer[2][2] <= 8'b11111111 & (~line_block_mask);
			
			display_buffer[3][0] <= 8'b11111111;
			display_buffer[3][1] <= (jogadas[1] | line_block_mask) & (~line_block_mask);;
			display_buffer[3][2] <= 8'b11111111 & (~line_block_mask);
			
			display_buffer[4][0] <= 8'b11111111;
			display_buffer[4][1] <= 8'b11111111 & (~line_block_mask);
			display_buffer[4][2] <= (jogadas[2] | line_block_mask) & (~line_block_mask);;
			
			display_buffer[5][0] <= jogadas[3] | line_block_mask;
			display_buffer[5][1] <= (jogadas[3] | line_block_mask) & (~line_block_mask);;
			display_buffer[5][2] <= 8'b11111111 & (~line_block_mask);
			
			
			
			{display_buffer[7][0], display_buffer[6][0], display_buffer[1][0], display_buffer[0][0]} <= 32'hFFFFFFFF << pontos;
			{display_buffer[7][2], display_buffer[6][2], display_buffer[1][2], display_buffer[0][2]} <= 32'hFFFFFFFF << pontos;
		
		end
	end
	
	
	wire [2:0] selected_col;
	
	contador_m #(.M(8), .N(3)) col_selector (
		.clock(display_refresh_clock),
		.zera_as(reset_display),
		.zera_s(1'b0),
		.conta(show_display),
		.Q(selected_col),
		.fim(),
		.meio()
	);
	
	always @(selected_col) begin
	
		case (selected_col) 
			3'b000: begin
				matriz_col 	<= 8'b00000001;
				matriz_r 	<= display_buffer[0][0];
				matriz_g 	<= display_buffer[0][1];
				matriz_b 	<= display_buffer[0][2];
			end
			3'b001: begin
				matriz_col 	<= 8'b00000010;
				matriz_r 	<= display_buffer[1][0];
				matriz_g 	<= display_buffer[1][1];
				matriz_b 	<= display_buffer[1][2];
			end
			3'b010: begin
				matriz_col 	<= 8'b00000100;
				matriz_r 	<= display_buffer[2][0];
				matriz_g 	<= display_buffer[2][1];
				matriz_b 	<= display_buffer[2][2];
			end
			3'b011: begin
				matriz_col 	<= 8'b00001000;
				matriz_r 	<= display_buffer[3][0];
				matriz_g 	<= display_buffer[3][1];
				matriz_b 	<= display_buffer[3][2];
			end
			3'b100: begin
				matriz_col 	<= 8'b00010000;
				matriz_r 	<= display_buffer[4][0];
				matriz_g 	<= display_buffer[4][1];
				matriz_b 	<= display_buffer[4][2];
			end
			3'b101: begin
				matriz_col 	<= 8'b00100000;
				matriz_r 	<= display_buffer[5][0];
				matriz_g 	<= display_buffer[5][1];
				matriz_b 	<= display_buffer[5][2];
			end
			3'b110: begin
				matriz_col 	<= 8'b01000000;
				matriz_r 	<= display_buffer[6][0];
				matriz_g 	<= display_buffer[6][1];
				matriz_b 	<= display_buffer[6][2];
			end
			3'b111: begin
				matriz_col 	<= 8'b10000000;
				matriz_r 	<= display_buffer[7][0];
				matriz_g 	<= display_buffer[7][1];
				matriz_b 	<= display_buffer[7][2];
			end
		endcase
	
	end

	

endmodule