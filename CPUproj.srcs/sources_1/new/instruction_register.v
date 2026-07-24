`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Malcolm Mohr
// 
// Create Date: 07/24/2026 02:41:44 PM
// Design Name: 16-bit CPU
// Module Name: instruction_register
// Project Name: 16-bit CPU
// Target Devices: Spartan-7 XC7S25 (Arty S7-25)
// Tool Versions: 2025.2
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Made IR
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instruction_register(
        input wire clk,
        input wire reset,
        input wire write,
        
        input wire [15:0] data_in,
        output reg [15:0] data_out
    );
    
    always @(posedge clk) begin
        if (reset) begin
            data_out <= 16'b0;
        end
        else if (write) begin
            data_out <= data_in;
        end
    end
    
endmodule
