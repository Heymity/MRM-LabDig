module MRMFD (

)

//registrador_parametrizavel #(.M(2)) nivel REG (
//    .clock(),
//    .clear(),
//    .enable(),
//    .D(),
//    .Q()
//)

random_number Rand (
    .gerar(),
    .seed(),
    .numero()
)

registrador_parametrizavel proxima_jogada (
    .clock(),
    .clear(),
    .enable(),
    .D(),
    .Q()
)

edge_detector Edge (
    .clock(),
    .reset(),
    .sinal(),
    .pulso()
)

registrador_parametrizavel input_jogada (
    .clock(),
    .clear(),
    .enable(),
    .D(),
    .Q()
)

contador_m #(.M(4), .N(2)) ContRand (
    .clock(),
    .zera_as(),
    .zera_s(),
    .conta(),
    .Q(),
    .fim(),
    .meio()
)

ram_8x4 RAM (
    .data_in(),
    .write(),
    .data_out1(),
    .data_out2()
)

mux2x1 MuxJogada (
    .D0(),
    .D1(),
    .SEL(),
    .OUT()
)

comparador_jogadas CompJ (
    .A(),
    .B(),
    .enable(),
    .AEB()
)

contador_periodo ContP (
    .clock(),
    .rst(),
    .conta(),
    .Q(),
    .fim()
)

contador_jogadas ContJ (
    .clock(),
    .rst(),
    .conta(),
    .Q(),
    .fim()
)

matriz_controller MatrizC (
    .display_refresh_clock(),
    .reset_display(),
    .show_display(),
    .matriz_r(),
    .matriz_g(),
    .matriz_b()
)

endmodule