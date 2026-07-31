`timescale 1ns / 1ps

module ALU_tb;

    reg [15:0] a, b;
    reg [1:0] op;
    wire [15:0] y;
    wire zero_flag, neg_flag, carry_flag, over_flag;

    ALU uut (
        .a(a),
        .b(b),
        .op(op),
        .y(y),
        .zero_flag(zero_flag),
        .neg_flag(neg_flag),
        .carry_flag(carry_flag),
        .over_flag(over_flag)
    );

    initial begin
        a = 16'd10; b = 16'd5; op = 2'b00; // ADD
        #10;
        a = 16'd10; b = 16'd5; op = 2'b01; // SUB
        #10;
        a = 16'hFFFF; b = 16'd1; op = 2'b00; // overflow test
        #10;
        $finish;
    end

endmodule
