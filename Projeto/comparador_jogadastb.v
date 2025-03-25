`timescale 1ns/1ns

module comparador_jogadastb;

    reg [3:0] A, B;
    reg enable;
    wire AEB;

    comparador_jogadas dut (
        .A(A),
        .B(B),
        .enable(enable),
        .AEB(AEB)
    );

    initial begin
        $monitor("Time: %0t | A: %b | B: %b | enable: %b | AEB: %b", 
                 $time, A, B, enable, AEB);

        A = 4'b0000;
        B = 4'b0000;
        enable = 0;

        #1 enable = 1; A = 4'b0001; B = 4'b0001;
        #1 enable = 1; A = 4'b0010; B = 4'b0011;
        #1 enable = 0; A = 4'b0100; B = 4'b0100;
        #1 enable = 1; A = 4'b0110; B = 4'b0111;
        #1 enable = 1; A = 4'b1000; B = 4'b1000;
        #1 enable = 0; A = 4'b1010; B = 4'b1011;
        #5 $finish;
    end

endmodule

module comparador_jogadas(
input [3:0] A, B,
input enable,
output reg AEB
);

always @(A or B) begin
    if (enable) begin
        if (A == B) begin
            AEB <= 1;
        end
        else begin
            AEB <= 0;
        end
    end
    else begin
        AEB <= 0;
    end
end

endmodule