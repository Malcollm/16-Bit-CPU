`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Malcolm Mohr
// 
// Create Date: 07/25/2026 07:31:49 PM
// Design Name: 16-bit CPU
// Module Name: subroutine_register
// Project Name: 16-bit CPU
// Target Devices: Spartan-7 XC7S25 (Arty S7-25)
// Tool Versions: 2025.2
// Description: register hold address for when RET (return to subroutine) is called
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Made register
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module subroutine_register(
        input wire clk,
        input wire write,
        
        input wire [15:0] data_in,
        output reg [15:0] data_out
    );
    
    always @(posedge clk) begin
        if (write) begin
            data_out <= data_in;
        end
    end
    
endmodule
