`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Malcolm Mohr
// 
// Create Date: 07/20/2026 09:10:33 PM
// Design Name: 16-bit CPU
// Module Name: ALU
// Project Name: 16-bit CPU
// Target Devices: Spartan-7 XC7S25 (Arty S7-25)
// Tool Versions: Vivado 2025.2
// Description: Combinational 16-bit ALU. Computes add/sub/and/or and raw
//              condition flags (zero, negative, carry, odd). Flags are
//              NOT latched here - see flag_register.v for the external
//              flag storage that gates flag updates.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Fixed zero_flag/neg_flag to check y instead of wide arith reg
// Revision 0.03 - Removed unused clk input (ALU is purely combinational) 
// Additional Comments:
// carry_flag is only meaningful for OP_ADD/OP_SUB; forced to 0 for AND/OR.
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
    output reg overflow_flag
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
        
        case(op)
            OP_ADD: begin
                overflow_flag = (a[15] == b[15]) && (y[15] != a[15]);
                carry_flag = arith[16];
            end
            
            OP_SUB: begin
                overflow_flag = (a[15] != b[15]) && (y[15] != a[15]);
                carry_flag = arith[16];
            end
            
            default: begin
                overflow_flag = 1'b0;  // meaningless for AND/OR
                carry_flag = 1'b0;
            end
        endcase

        y = arith[15:0];

        zero_flag  = (y == 16'b0);
        neg_flag   = y[15];
    end
endmodule
