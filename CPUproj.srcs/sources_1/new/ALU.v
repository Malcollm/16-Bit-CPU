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
// Revision 0.04 - Added more logical operations
// Additional Comments:
// carry_flag is only meaningful for OP_ADD/OP_SUB; forced to 0 for AND/OR.
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [2:0] op,

    output reg [15:0] y,

    // flags
    output reg zero_flag,
    output reg neg_flag,
    output reg carry_flag,
    output reg over_flag
    );

    reg [16:0] arith;

    localparam OP_ADD = 3'b000;
    localparam OP_SUB = 3'b001;
    localparam OP_AND = 3'b010;
    localparam OP_OR  = 3'b011;
    localparam OP_XOR = 3'b100;
    localparam OP_NOT = 3'b101;
    localparam OP_LSL = 3'b110;
    localparam OP_LSR = 3'b111;

    always @(*) begin
        case(op)
            OP_ADD:  arith = {1'b0, a} + {1'b0, b};
            OP_SUB:  arith = {1'b0, a} - {1'b0, b};
            OP_AND:  arith = {1'b0, a & b};
            OP_OR:   arith = {1'b0, a | b};
            OP_XOR:  arith = {1'b0, a ^ b};
            OP_NOT:  arith = {1'b0, ~a};
            OP_LSL:  arith = {a, 1'b0};
            OP_LSR:  arith = {a[0], 1'b0, a[15:1]};
            default: arith = 17'b0;
        endcase
        
        y = arith[15:0];
        
        // Update flags
        case(op)
            OP_ADD: begin
                over_flag = (a[15] == b[15]) && (y[15] != a[15]);
                carry_flag = arith[16];
            end
            
            OP_SUB: begin
                over_flag = (a[15] != b[15]) && (y[15] != a[15]);
                carry_flag = arith[16];
            end
            
            default: begin
                over_flag = 1'b0;  // meaningless for AND/OR
                carry_flag = 1'b0;
            end
        endcase

        zero_flag  = (y == 16'b0);
        neg_flag   = y[15];
    end
endmodule
