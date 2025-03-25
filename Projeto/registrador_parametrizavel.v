module registrador_parametrizavel #(parameter M = 4)
(
    input        clock,
    input        clear,
    input        enable,
    input  [M-1:0] D,
    output [M-1:0] Q
);

    reg [M-1:0] IQ;

    always @(posedge clock or posedge clear) begin
        if (clear)
            IQ <= 0;
        else if (enable)
            IQ <= D;
    end

    assign Q = IQ;

endmodule