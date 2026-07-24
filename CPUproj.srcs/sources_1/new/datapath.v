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
// Dependencies: ALU.v, flag_register.v
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Added ALU and flag register to datapath
// Revision 0.03 - Added the register file to datapath
// Revision 0.04 - Added PC and IR to datapath
// Revision 0.05 - Added IO register to datapath
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module datapath(
    input wire clk
    );
    
    wire [3:0] flags;           // Flags from ALU
    wire [15:0] reg_data_a;     // Register file outputs
    wire [15:0] reg_data_b;
    wire [15:0] reg_data_in;    // Register file input 
    wire [15:0] alu_data;       // ALU output
    wire [15:0] in_data;        // Input register output
    
    wire reset;
    wire alu_out;               // ALU outputing to register file
    
    assign reg_data_in = alu_out ? alu_data : in_data;
    
    ALU i_alu (
        .zero_flag(flags[0]),
        .neg_flag(flags[1]),
        .carry_flag(flags[2]),
        .over_flag(flags[3]),
        .y(alu_data)
    );
    
    flag_register i_flag_register (
        .flag_inputs(flags),
        .clk(clk),
        .reset(reset)
    );
    
    register_file i_register_file (
        .clk(clk),
        .out_a(reg_data_a),
        .out_b(reg_data_b),
        .data_in(reg_data_in)
    );
    
    program_counter i_program_counter (
        .clk(clk),
        .reset(reset),
        .addr(reg_data_a)
    );
    
    instruction_register i_instruction_register (
        .clk(clk),
        .reset(reset)
    );
    
    io_register i_io_register (
        .clk(clk),
        .reset(reset),
        .out_in(reg_data_a),
        .in_out(in_data)
    );
endmodule
