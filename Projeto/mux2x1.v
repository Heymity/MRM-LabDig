module mux2x1 (
    input reg [3:0] D0,
    input reg [3:0] D1,
    input      SEL,
    output reg [3:0] OUT
);

always @(*) begin
    case (SEL)
        1'b0:    OUT = D0;
        1'b1:    OUT = D1;
        default: OUT = 4'b0000; // saida em 1
    endcase
end

endmodule
