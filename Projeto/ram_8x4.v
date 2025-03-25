// RAM personalizada que funciona como uma fila. Tem como outputs os dois ultimos elementos da fila.
// Os elementos são inseridos no inicio da fila e o ultimo elemento é descartado quando um novo é inserido.
// Para inserir elementos, o input write deve ir de 0 para 1.

module ram_8x4 (
    input      [3:0] data_in,
    input            write,
    output wire [3:0] data_out1,
    output wire [3:0] data_out2
);

    reg [3:0] data [7:0];

    integer i;
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            data[i] = 4'b0000;
        end
    end

    always @ (posedge write) begin
        data[7] <= data[6];
        data[6] <= data[5];
        data[5] <= data[4];
        data[4] <= data[3];
        data[3] <= data[2];
        data[2] <= data[1];
        data[1] <= data[0];
        data[0] <= data_in;
    end

        assign data_out1 = data[7];
        assign data_out2 = data[6];

endmodule