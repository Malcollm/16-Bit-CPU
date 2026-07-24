`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Malcolm Mohr
// 
// Create Date: 07/24/2026 04:18:11 PM
// Design Name: 16-bit CPU
// Module Name: io_register
// Project Name: 16-bit CPU
// Target Devices: Spartan-7 XC7S25 (Arty S7-25)
// Tool Versions: 2025.2
// Description: Holds two 16 big ports one output and one input
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Made IO register
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module io_register(
        input wire clk,
        input wire reset,
        input wire latch_out,   // Output register update
        
        input wire [15:0] out_in,   // Output register input
        output wire [15:0] out_out, // Output register output
        
        input wire [15:0] in_in,    // Input register input
        output wire [15:0] in_out   // Input register output
    );
    
    reg [15:0] out_data;    // Output register data
    reg [15:0] in_data;     // Input register data
    
    assign out_out = out_data;
    assign in_out  = in_data;
    
    always @(posedge clk) begin
        if (reset) begin
            out_data <= 16'b0;
            in_data <= 16'b0;
        end
        else begin
            in_data <= in_in;
            
            if (latch_out) begin
                out_data <= out_in;
            end
        end
    end
    
endmodule
