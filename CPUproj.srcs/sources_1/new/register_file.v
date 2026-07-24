`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Malcolm Mohr
// 
// Create Date: 07/24/2026 01:26:10 PM
// Design Name: 16-bit CPU
// Module Name: register_file
// Project Name: 16-bit CPU
// Target Devices: Spartan-7 XC7S25 (Arty S7-25)
// Tool Versions: 2025.2
// Description: Holds 16 16-bit registers
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Added register file
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register_file(
        input wire [3:0] addr_a,
        input wire [3:0] addr_b,
        input wire [3:0] addr_w,
        
        input wire write,
        input wire clear_reg, // Clears register at write address
        
        input wire clk,
        
        input wire [15:0] data_in,
        
        output reg [15:0] out_a,
        output reg [15:0] out_b
    );
    
    reg [15:0] data [0:15]; // Where data is stored
    
    always @(posedge clk) begin
        if (clear_reg) begin
            data[addr_w] <= 16'b0;
        end
    
        if (write) begin
            data[addr_w] <= data_in;
        end
    end
    
    always @(*) begin
        out_a = data[addr_a];
        out_b = data[addr_b];
    end
    
endmodule
