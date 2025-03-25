`timescale 1ns/1ns

module ram_8x4tb;
    reg[3:0] data_in;
    wire[3:0] data_out1;
    wire[3:0] data_out2;
    reg write_enable;

    ram_8x4 dut (
        .data_in      ( data_in      ),
        .write        ( write_enable ),
        .data_out1    ( data_out1    ),
        .data_out2    ( data_out2    )
    );

    initial begin
        $monitor("Time: %0t | data_in: %b | write_enable: %b | data_out1: %b | data_out2: %b", 
                 $time, data_in, write_enable, data_out1, data_out2);

        data_in = 4'b0000;
        write_enable = 0;
        #1 write_enable = 1;
        data_in = 4'b0001;
        #1 write_enable = 0;
        data_in = 4'b0010;
        #1 write_enable = 1;
        data_in = 4'b0011;
        #1 write_enable = 0;
        data_in = 4'b0100;
        #1 write_enable = 1;
        data_in = 4'b0101;
        #1 write_enable = 0;
        data_in = 4'b0110;
        #1 write_enable = 1;
        data_in = 4'b0111;
        #1 write_enable = 0;
        data_in = 4'b1000;
        #1 write_enable = 1;
        data_in = 4'b1001;
        #1 write_enable = 0;
        data_in = 4'b1010;
        #1 write_enable = 1;
        data_in = 4'b1011;
        #1 write_enable = 0;
        data_in = 4'b1100;
        #1 write_enable = 1;
        data_in = 4'b1101;
        #1 write_enable = 0;
        data_in = 4'b1110;
        #1 write_enable = 1;
        data_in = 4'b1111;
        #1 write_enable = 0;
        $finish;
    end
endmodule

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