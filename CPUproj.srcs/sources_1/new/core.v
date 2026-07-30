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
// Dependencies: datapath.v, memory.v
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Added memory and datapath
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module core(
        input wire clk,
        input wire reset
    );
    
    wire mem_to_reg;
    wire alu_to_reg;
    wire ir_to_reg;
    wire pc_to_reg;
    wire in_to_reg;
    
    wire reg_to_pc;
    wire srr_to_pc;
    
    wire reg_to_mem;
    
    wire [15:0] ir_out;
    wire [15:0] ir_in;
    
    wire [15:0] mem_out;
    wire [15:0] mem_in;

    wire [15:0] alu_out;
    
    wire [15:0] srr_out;
    
    wire [15:0] in_out;
    wire [15:0] out_in;
    
    wire [15:0] pc_in;
    wire [15:0] pc_out;
    
    wire [15:0] reg_out_a;
    wire [15:0] reg_in;
    
    assign reg_in = mem_to_reg ? mem_out :
                    alu_to_reg ? alu_out : 
                    ir_to_reg ? ir_out :
                    pc_to_reg ? pc_out :
                    ir_out;
    
    assign mem_in = reg_out_a;
    assign ir_in = mem_out;
    assign pc_in = reg_to_pc ? reg_out_a : srr_out;
    assign out_in = reg_out_a;
    
    datapath i_datapath (
        .clk(clk),
        .reset(reset),
        .reg_data_in(reg_in),
        .alu_out(alu_out),
        .ir_out(ir_out),
        .in_out(in_out),
        .out_in(out_in),
        .pc_out(pc_out),
        .reg_data_a(reg_out_a),
        .ir_out(ir_out),
        .srr_out(srr_out)
        
    );
    
    memory i_memory (
        .clk(clk),
        .mem_out(mem_out),
        .mem_in(mem_in),
        .write(reg_to_mem)
    );
    
endmodule
