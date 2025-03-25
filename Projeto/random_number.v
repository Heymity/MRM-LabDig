//Gerador de jogada aleatória.

module random_number (
    input gerar,
    input [1:0] seed,
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