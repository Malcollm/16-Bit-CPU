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
// Revision 0.03 - Added control unit
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module core(
        input wire clk,
        input wire reset,
        
        input wire [15:0] in_in,
        output wire [15:0] out_out
    );
    
    wire mem_to_reg;
    wire alu_to_reg;
    wire ir_to_reg;
    wire pc_to_reg;
    wire in_to_reg;
    wire reg_to_reg;
    
    wire reg_to_pc;
    wire srr_to_pc;
    
    wire reg_to_mem;
    
    wire flag_en;
    
    wire [15:0] ir_out;
    wire [15:0] ir_in;
    
    wire [15:0] mem_out;
    wire [15:0] mem_in;
    wire [15:0] mem_addr;

    wire [15:0] alu_out;
    wire [2:0] alu_op;
    wire [3:0] flag_out;
    
    wire pc_to_srr;
    wire [15:0] srr_out;
    
    wire reg_to_out;
    wire [15:0] in_out;
    wire [15:0] out_in;
    
    wire pc_inc;
    wire [15:0] pc_in;
    wire [15:0] pc_out;
    
    wire [15:0] reg_out_a;
    wire [15:0] reg_in;
    
    wire reg_write;
    wire [3:0] reg_addr_a;
    wire [3:0] reg_addr_b;
    wire [3:0] reg_addr_w;
    
    assign reg_in = mem_to_reg ? mem_out :
                    alu_to_reg ? alu_out : 
                    ir_to_reg ? ir_out :
                    pc_to_reg ? pc_out :
                    ir_to_reg ? ir_out :
                    reg_out_a;
    
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
        .out_in(out_in),
        .pc_out(pc_out),
        .reg_data_a(reg_out_a),
        .reg_data_b(reg_out_b),
        .srr_out(srr_out),
        .flag_out(flag_out),
        .in_in(in_in),
        .out_out(out_out),
        .reg_addr_a(reg_addr_a),
        .reg_addr_b(reg_addr_b),
        .reg_addr_w(reg_addr_w),
        .flag_en(flag_en),
        .alu_op(alu_op),
        .reg_write(alu_to_reg | mem_to_reg | ir_to_reg | pc_to_reg | in_to_reg | reg_to_reg),
        .pc_write(reg_to_pc | srr_to_pc),
        .pc_inc(pc_inc),
        .srr_write(pc_to_srr),
        .out_write(reg_to_out)
    );
    
    memory i_memory (
        .clk(clk),
        .mem_out(mem_out),
        .mem_in(mem_in),
        .addr(mem_addr),
        .write(reg_to_mem)
    );
    
    control_unit i_control_unit (
        .clk(clk),
        .reset(reset),
        .ir_out(ir_out),
        .flags(flag_out),
        .flag_en(flag_en),
        .alu_op(alu_op),
        .alu_to_reg(alu_to_reg),
        .reg_addr_a(reg_addr_a),
        .reg_addr_b(reg_addr_b),
        .reg_addr_w(reg_addr_w),
        .pc_inc(pc_inc),
        .reg_to_pc(reg_to_pc),
        .pc_to_srr(pc_to_srr),
        .srr_to_pc(srr_to_pc),
        .mem_addr(mem_addr),
        .mem_to_reg(mem_to_reg),
        .reg_out_a(reg_out_a),
        .reg_out_b(reg_out_b),
        .reg_to_mem(reg_to_mem),
        .in_to_reg(in_to_reg),
        .reg_to_out(reg_to_out),
        .reg_to_reg(reg_to_reg)
    );
    
endmodule
