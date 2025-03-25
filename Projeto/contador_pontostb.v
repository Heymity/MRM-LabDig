`timescale 1ns/1ns

module contador_pontostb;

reg acertou;
reg errou;
wire [5:0] pontos;
wire [2:0] linhas_bloq;

contador_pontos dut (
    .acertou(acertou),
    .errou(errou),
    .enable(1'b1),
    .pontos(pontos),
    .linhas_bloq(linhas_bloq)
);

initial begin
    acertou = 0;
    errou = 0;

    $monitor("Time: %0t | acertou: %b | errou: %b | pontos: %d | linhas_bloq: %d", 
             $time, acertou, errou, pontos, linhas_bloq);

    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 1;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #1 acertou = 0; errou = 0;
    #1 acertou = 1; errou = 0;
    #5 $finish;
end

endmodule

module contador_pontos (
    input acertou,
    input errou,
    input enable,
    output reg [5:0] pontos,
    output reg [2:0] linhas_bloq
);

initial begin
    pontos = 0;
    linhas_bloq = 0;
end

always @ (posedge acertou or posedge errou) begin
    if (enable) begin
        if (acertou) begin
            if (pontos == 32) begin
                pontos = 32;
            end else begin
                pontos = pontos + 1;
            end
        end else if (errou) begin
            if (pontos == 0) begin
                pontos = 0;
        end else
            pontos = pontos - 1;
        end
    end
end

always @ (pontos) begin
    if (pontos == 0) begin
        linhas_bloq = 0;
    end else if (pontos == 4 || pontos == 7) begin
        linhas_bloq = 1;
    end else if (pontos == 8 || pontos == 11) begin
        linhas_bloq = 2;
    end else if (pontos == 12 || pontos == 15) begin
        linhas_bloq = 3;
    end else if (pontos == 16 || pontos == 19) begin
        linhas_bloq = 4;
    end else if (pontos == 20 || pontos == 23) begin
        linhas_bloq = 5;
    end else if (pontos == 24 || pontos == 27) begin
        linhas_bloq = 6;
    end else if (pontos == 28) begin
        linhas_bloq = 7;
    end
end

endmodule