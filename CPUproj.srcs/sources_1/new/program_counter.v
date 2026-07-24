`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Malcolm Mohr
// 
// Create Date: 07/24/2026 02:19:21 PM
// Design Name: 16-bit CPU
// Module Name: program_counter
// Project Name: 16-bit CPU
// Target Devices: Spartan-7 XC7S25 (Arty S7-25)
// Tool Versions: 2025.2
// Description: 
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Made PC
// Revision 0.03 - Added controlled increment
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module program_counter(
        input wire clk,
        
        input wire [15:0] addr,
        
        input wire write,
        input wire reset,
        input wire inc,
        
        output reg [15:0] out
    );
    
    always @(posedge clk) begin
        if (reset) begin
            out <= 16'b0;
        end
        else if (write) begin
            out <= addr;
        end
        else if (inc) begin
            out <= out + 1;
        end
    end
    
endmodule
