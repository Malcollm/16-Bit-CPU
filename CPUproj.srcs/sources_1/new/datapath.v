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
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module datapath(
    input wire clk
    );
    
    wire [3:0] flags;
    wire [15:0] reg_data_a;
    wire [15:0] reg_data_b;
    
    ALU i_alu (
        .zero_flag(flags[0]),
        .neg_flag(flags[1]),
        .carry_flag(flags[2]),
        .over_flag(flags[3])
    );
    
    flag_register i_flag_register (
        .flag_inputs(flags),
        .clk(clk)
    );
    
    register_file i_register_file (
        .clk(clk),
        .out_a(reg_data_a),
        .out_b(reg_data_b)
    );
endmodule
