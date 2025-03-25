`timescale 1ns/1ns

module contador_jogadastb;

    reg clock;
    reg rst;
    reg conta;
    wire [3:0] Q;
    wire fim;

    contador_jogadas #(.M(5), .N(4)) dut (
        .clock(clock),
        .rst(rst),
        .conta(conta),
        .Q(Q),
        .fim(fim)
    );

    always #0.5 clock = ~clock;

    initial begin
        $monitor("Time: %0t | clock: %b | rst: %b | conta: %b | Q: %b | fim: %b", 
                 $time, clock, rst, conta, Q, fim);

        clock = 0;
        rst = 0;
        conta = 0;

        #1 rst = 1;
        #1 rst = 0; conta = 1;
        #10 conta = 0;
        #2 conta = 1;
        #10 rst = 1;
        #1 rst = 0; conta = 1;
        #10 $finish;
    end

endmodule

module contador_jogadas #(parameter M=32, N=6)
(
    input  wire          clock,
    input  wire          rst,
    input  wire          conta,
    output reg  [N-1:0]  Q,
    output reg           fim
    );

    always @(posedge clock or posedge rst) begin
        if (rst) begin
            Q <= 0;
        end else if (clock) begin
            if (conta) begin
                if (Q == M) begin
                    Q <= 0;
                end else begin
                    Q <= Q + 1'b1;
                end
            end
        end
    end

    always @ (Q)
        if (Q == M)   fim = 1;
        else          fim = 0;

endmodule
