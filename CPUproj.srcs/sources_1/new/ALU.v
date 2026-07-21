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
    input wire clk,
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [1:0] op,
    input wire flag_we, // Flag reg write enable
    
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
    
    always @(posedge clk) begin
        case(op)
            OP_ADD: arith = a + b;
            OP_SUB: arith = a - b;
            OP_AND: arith = a & b;
            OP_OR:  arith = a | b;
        endcase
        
        y = arith[15:0];
        
        if (flag_we) begin
            zero_flag <= ~(|arith);
            neg_flag <= arith[15];
            carry_flag <= arith[16];
            odd_flag <= arith[0];
        end
    end
endmodule
