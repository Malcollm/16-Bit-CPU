`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Malcolm Mohr
// 
// Create Date: 07/23/2026 07:18:47 PM
// Design Name: 16-bit CPU
// Module Name: datapath
// Project Name: 16-bit CPU
// Target Devices: Spartan-7 XC7S25 (Arty S7-25)
// Tool Versions: Vivado 2025.2
// Description: 
// 
// Dependencies: ALU.v, flag_register.v, register_file.v, program_counter.v, io_register.v
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Added ALU and flag register to datapath
// Revision 0.03 - Added the register file to datapath
// Revision 0.04 - Added PC and IR to datapath
// Revision 0.05 - Added IO register to datapath
// Revision 0.06 - Removed IR
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module datapath(
    input wire clk,
    input wire reset,
    
    input wire [15:0] reg_data_in,    // Register file input
    
    output wire [15:0] pc_out,
    output wire [15:0] alu_out,
    output wire [15:0] in_out,
    
    input wire [1:0] alu_op,
    input wire flag_en,
    output wire [3:0] flag_out,
    
    input wire reg_write,
    input wire [3:0] reg_addr_a,
    input wire [3:0] reg_addr_b,
    input wire [3:0] reg_addr_w,
    
    input wire pc_inc,
    input wire pc_write,
    input wire [15:0] pc_in,
    
    input wire latch_out,
    input wire [15:0] in_in,
    output wire [15:0] out_out
    );
    
    wire [3:0] flags;           // Flags from ALU
    wire [15:0] reg_data_a;     // Register file outputs
    wire [15:0] reg_data_b;
    
    ALU i_alu (
        .zero_flag(flags[0]),
        .neg_flag(flags[1]),
        .carry_flag(flags[2]),
        .over_flag(flags[3]),
        .a(reg_data_a),
        .b(reg_data_b),
        .y(alu_out),
        .op(alu_op)
    );
    
    flag_register i_flag_register (
        .flag_inputs(flags),
        .flag_outputs(flag_out),
        .enable(flag_en),
        .clk(clk),
        .reset(reset)
    );
    
    register_file i_register_file (
        .clk(clk),
        .out_a(reg_data_a),
        .out_b(reg_data_b),
        .data_in(reg_data_in),
        .write(reg_write),
        .addr_a(reg_addr_a),
        .addr_b(reg_addr_b),
        .addr_w(reg_addr_w)
    );
    
    program_counter i_program_counter (
        .clk(clk),
        .reset(reset),
        .addr(pc_in),
        .out(pc_out),
        .inc(pc_inc),
        .write(pc_write)
    );
    
    io_register i_io_register (
        .clk(clk),
        .reset(reset),
        .out_in(reg_data_a),
        .out_out(out_out),
        .in_out(in_out),
        .in_in(in_in),
        .latch_out(latch_out)
    );
endmodule
