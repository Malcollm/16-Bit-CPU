`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2026 05:08:18 PM
// Design Name: 16-bit CPU
// Module Name: program_rom
// Project Name: 16-bit CPU
// Target Devices: Spartan-7 XC7S25 (Arty S7-25)
// Tool Versions: 2025.2
// Description: Program memory
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Made ROM
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module program_rom (
    input wire clk,
    input wire [15:0] addr,
    output reg [15:0] rom_out
);

    reg [15:0] rom [0:4];

    initial begin
        $readmemh("program.mem", rom);
    end

    always @(posedge clk) begin
        rom_out <= rom[addr];
    end

endmodule