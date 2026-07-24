`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2026 06:59:45 PM
// Design Name: 16-bit CPU
// Module Name: flag_register
// Project Name: 16-bit CPU
// Target Devices: Spartan-7 XC7S25 (Arty S7-25)
// Tool Versions: Vivado 2025.2
// Description: 4 bit register that hold information about flags from the ALU
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Made register
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module flag_register(
        input wire clk,
        input wire enable,
        input wire reset,
        input wire [3:0] flag_inputs, // [zero, neg, carry, over]
        
        output reg [3:0] flag_outputs
    );
    
    always @(posedge clk) begin
        if (reset) begin
            flag_outputs <= 4'b0000;
        end
        else if (enable) begin
            flag_outputs <= flag_inputs;
        end
    end
endmodule
