`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Malcolm Mohr
// 
// Create Date: 07/30/2026 04:32:02 PM
// Design Name: 16-bit CPU
// Module Name: control_unit
// Project Name: 16-bit CPU
// Target Devices: Spartan-7 XC7S25 (Arty S7-25)
// Tool Versions: 2025.2
// Description: controls flow of data throughout the memory and datapath
// 
// Dependencies: sequencer.v
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Started control unit
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control_unit(
        input wire clk,
        input wire reset,
        input wire [15:0] ir_out,
        output reg flag_en,
        input wire [3:0] flags,
        
        output reg [3:0] reg_addr_a,
        output reg [3:0] reg_addr_b,
        output reg [3:0] reg_addr_w
    );
    
    wire [2:0] cycle_data;
    
    localparam ADD = 4'b0000;
    localparam SUB = 4'b0001;
    localparam LOG = 4'b0010;
    localparam JMP = 4'b0011;
    localparam JST = 4'b0100;
    localparam RET = 4'b0101;
    localparam LD = 4'b0110;
    localparam LDR = 4'b0111;
    localparam ST = 4'b1000;
    localparam STR = 4'b1001;
    localparam IN = 4'b1010;
    localparam OUT = 4'b1011;
    localparam MOV = 4'b1100;
    localparam HLT = 4'b1101;
    
    sequencer i_sequencer (
        .clk(clk),
        .reset(reset),
        .cycle_data(cycle_data)
    );
    
    always @(*) begin
        flag_en = 1'b0;
    
        case (ir_out[3:0])
            ADD: begin
                flag_en = 1'b1;
                reg_addr_a = ir_out[15:12];
            end
        endcase
    end
    
endmodule
