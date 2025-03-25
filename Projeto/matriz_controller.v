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
			display_buffer[3][1] <= (jogadas[1] | line_block_mask) & (~line_block_mask);
			display_buffer[3][2] <= 8'b11111111 & (~line_block_mask);
			
			display_buffer[4][0] <= 8'b11111111;
			display_buffer[4][1] <= 8'b11111111 & (~line_block_mask);
			display_buffer[4][2] <= (jogadas[2] | line_block_mask) & (~line_block_mask);
			
			display_buffer[5][0] <= jogadas[3] | line_block_mask;
			display_buffer[5][1] <= (jogadas[3] | line_block_mask) & (~line_block_mask);
			display_buffer[5][2] <= 8'b11111111 & (~line_block_mask);
			
			
			
			{display_buffer[0][0], display_buffer[1][0], display_buffer[6][0], display_buffer[7][0]} <= 32'hFFFFFFFF >> pontos;
			{display_buffer[0][2], display_buffer[1][2], display_buffer[6][2], display_buffer[7][2]} <= 32'hFFFFFFFF >> pontos;
		
		end
	end
	
	
	wire [2:0] selected_col;
	wire [1:0] output_color;
	wire next_col;
	
	contador_m #(.M(3), .N(2)) color_selector (
		.clock(display_refresh_clock),
		.zera_as(reset_display),
		.zera_s(1'b0),
		.conta(show_display),
		.Q(output_color),
		.fim(next_col),
		.meio()
	);
	
	contador_m #(.M(8), .N(3)) column_selector (
		.clock(display_refresh_clock),
		.zera_as(reset_display),
		.zera_s(1'b0),
		.conta(next_col),
		.Q(selected_col),
		.fim(),
		.meio()
	);
	
	reg [7:0] line_output_r, line_output_g, line_output_b;
	
	
	always @(selected_col) begin
		
		matriz_r <= 8'b11111111;
		matriz_g <= 8'b11111111;
		matriz_b <= 8'b11111111;
		
		matriz_col <= 8'b00000001 << selected_col;
	
		case (selected_col) 
			3'b000: begin
				line_output_r 	<= display_buffer[0][0];
				line_output_g 	<= display_buffer[0][1];
				line_output_b 	<= display_buffer[0][2];
			end
			3'b001: begin
				line_output_r 	<= display_buffer[1][0];
				line_output_g 	<= display_buffer[1][1];
				line_output_b 	<= display_buffer[1][2];
			end
			3'b010: begin
				line_output_r	<= display_buffer[2][0];
				line_output_g	<= display_buffer[2][1];
				line_output_b	<= display_buffer[2][2];
			end
			3'b011: begin
				line_output_r	<= display_buffer[3][0];
				line_output_g	<= display_buffer[3][1];
				line_output_b	<= display_buffer[3][2];
			end
			3'b100: begin
				line_output_r 	<= display_buffer[4][0];
				line_output_g 	<= display_buffer[4][1];
				line_output_b 	<= display_buffer[4][2];
			end
			3'b101: begin
				line_output_r	<= display_buffer[5][0];
				line_output_g	<= display_buffer[5][1];
				line_output_b	<= display_buffer[5][2];
			end
			3'b110: begin
				line_output_r 	<= display_buffer[6][0];
				line_output_g 	<= display_buffer[6][1];
				line_output_b 	<= display_buffer[6][2];
			end
			3'b111: begin
				line_output_r 	<= display_buffer[7][0];
				line_output_g 	<= display_buffer[7][1];
				line_output_b 	<= display_buffer[7][2];
			end
		endcase
		
		case (output_color)
			2'b00: matriz_r <= line_output_r;
			2'b01: matriz_g <= line_output_g;
			2'b10: matriz_b <= line_output_b;
		endcase
	
	end

endmodule