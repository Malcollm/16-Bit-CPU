`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Malcolm Mohr
// 
// Create Date: 07/30/2026 04:35:42 PM
// Design Name: 16-bit CPU
// Module Name: sequencer
// Project Name: 16-bit CPU
// Target Devices: Spartan-7 XC7S25 (Arty S7-25)
// Tool Versions: 2025.2
// Description: Keeps track of the current cycle in a instruction
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Made sequencer
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sequencer(
        input wire clk,
        input wire reset,
        input wire comp,
        output reg [2:0] cycle_data
    );
    
    always @(posedge clk) begin
        if (reset | comp) begin
            cycle_data <= 3'b0;
        end
        else begin
            cycle_data <= cycle_data + 1;
        end
    end
    
endmodule
