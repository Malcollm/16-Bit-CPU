`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Malcolm Mohr
// 
// Create Date: 07/24/2026 05:41:40 PM
// Design Name: 16-bit CPU
// Module Name: memory
// Project Name: 16-bit CPU
// Target Devices: Spartan-7 XC7S25 (Arty S7-25)
// Tool Versions: 2025.2
// Description: 65535x 16-bit word memory
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Made memory module
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module memory(
        input wire clk,
        input wire write,

        input wire [15:0] mem_in,
        input wire [15:0] addr,
        output reg [15:0] mem_out
    );
    
    reg [15:0] mem [0:65535];
    
    always @(posedge clk) begin
        if (write) begin
            mem[addr] <= mem_in;
        end
        
        mem_out <= mem[addr];
    end
    
endmodule
