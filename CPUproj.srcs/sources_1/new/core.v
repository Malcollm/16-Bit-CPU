`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Malcolm Mohr
// 
// Create Date: 07/24/2026 06:03:15 PM
// Design Name: 16-bit CPU
// Module Name: core
// Project Name: 16-bit CPU
// Target Devices: Spartan-7 XC7S25 (Arty S7-25)
// Tool Versions: 2025.2
// Description: datapath + memory + control unit
// 
// Dependencies: datapath.v, memory.v, instruction_register.v
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Added IR, memory and datapath
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module core(
        input wire clk,
        input wire reset
    );
    
    wire mem_to_reg;
    wire alu_to_reg;
    
    wire [15:0] ir_in;
    wire [15:0] ir_out;
    
    wire [15:0] alu_out;
    wire [15:0] in_out;
    wire [15:0] mem_out;
    reg [15:0] reg_in;
    
    always @(*) begin
        if (mem_to_reg) begin
            reg_in = mem_out;
        end
        else if (alu_to_reg) begin
            reg_in = alu_out;
        end
        else begin
            reg_in = in_out;
        end
    end
    
    instruction_register i_instruction_register (
        .clk(clk),
        .reset(reset),
        .data_in(mem_out)
    );
    
    datapath i_datapath (
        .clk(clk),
        .reset(reset),
        .reg_data_in(reg_in),
        .alu_out(alu_out)
    );
    
    memory i_memory (
        .clk(clk),
        .mem_out(mem_out)
    );
    
endmodule
