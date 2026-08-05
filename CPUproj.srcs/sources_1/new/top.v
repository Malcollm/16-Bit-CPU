`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Malcolm Mohr
// 
// Create Date: 07/20/2026 08:48:19 PM
// Design Name: 16-bit CPU
// Module Name: top
// Project Name: 16-bit CPU
// Target Devices: Spartan-7 XC7S25 (Arty S7-25)
// Tool Versions: 2025.2
// Description: 
// 
// Dependencies: core.v
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Added IO pins
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input wire CLK100MHZ,
    input wire [7:0] ja,
    input wire [7:0] jb,
    
    input wire [3:0] btn,
    
    output wire [7:0] jc,
    output wire [7:0] jd
    );
    
    core i_core (
        .clk(CLK100MHZ),
        .in_in({ja, jb}),
        .out_out({jc, jd}),
        .reset(btn[0])
    );
    
endmodule
