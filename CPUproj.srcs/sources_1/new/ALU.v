`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Malcolm Mohr
// 
// Create Date: 07/20/2026 09:10:33 PM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [1:0] op,

    output reg [15:0] y,

    // flags
    output reg zero_flag,
    output reg neg_flag,
    output reg carry_flag,
    output reg odd_flag
    );

    reg [16:0] arith;

    localparam OP_ADD = 2'b00;
    localparam OP_SUB = 2'b01;
    localparam OP_AND = 2'b10;
    localparam OP_OR  = 2'b11;

    always @(*) begin
        case(op)
            OP_ADD:  arith = {1'b0, a} + {1'b0, b};
            OP_SUB:  arith = {1'b0, a} - {1'b0, b};
            OP_AND:  arith = {1'b0, a & b};
            OP_OR:   arith = {1'b0, a | b};
            default: arith = 17'b0;
        endcase

        y = arith[15:0];

        zero_flag  = (y == 16'b0);
        neg_flag   = y[15];
        carry_flag = (op == OP_ADD || op == OP_SUB) ? arith[16] : 1'b0;
        odd_flag   = y[0];
    end
endmodule
