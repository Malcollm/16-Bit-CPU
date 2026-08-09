`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Malcolm Mohr
// 
// Create Date: 07/30/2026 04:32:02 PM
// Design Name: 16-bit CPU
// Module Name: control_unit
// Project Name: 16-bit CPU
// Target Devices: Spartan-7 XC7S25 (Arty S7-25)
// Tool Versions: 2025.2
// Description: controls flow of data throughout the memory and datapath
// 
// Dependencies: sequencer.v
// 
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Started control unit
// Revision 0.03 - Added ops ADD SUB LOG
// Revision 0.04 - Added ops up to LD and LDR
// Revision 0.05 - Added ST and STR
// Revision 0.06 - Added IN and OUT
// Revision 0.07 - Added MOV
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control_unit(
        input wire clk,
        input wire reset,
        
        input wire [15:0] ir_out,
        output reg flag_en,
        input wire [3:0] flags,
        
        output reg alu_to_reg,
        input wire [15:0] reg_out_a,
        input wire [15:0] reg_out_b,
        output reg [3:0] reg_addr_a,
        output reg [3:0] reg_addr_b,
        output reg [3:0] reg_addr_w,
        
        output reg mem_to_reg,
        output reg [15:0] mem_addr,
        
        output reg [2:0] alu_op,
        
        output reg reg_to_out,
        output reg in_to_reg,
        
        output wire pc_inc,
        output reg reg_to_pc,
        output reg pc_to_srr,
        output reg pc_to_reg,
        output reg srr_to_pc, 
        output reg reg_to_mem,
        output reg reg_to_reg,
        output reg ir_to_reg,
        output reg prog_to_reg
    );
    
    wire [2:0] cycle_data;
    reg pc_next;
    reg sequencer_com;
    
    reg [15:0] temp_mem_addr;
    reg [3:0] con_dest;
    reg con_active;
    
    assign pc_inc = sequencer_com | pc_next;
    
    localparam ADD = 4'b0000;
    localparam SUB = 4'b0001;
    localparam LOG = 4'b0010;
    localparam JMP = 4'b0011;
    localparam JTS = 4'b0100;
    localparam RET = 4'b0101;
    localparam LD = 4'b0110;
    localparam LDR = 4'b0111;
    localparam ST = 4'b1000;
    localparam STR = 4'b1001;
    localparam IN = 4'b1010;
    localparam OUT = 4'b1011;
    localparam MOV = 4'b1100;
    localparam HLT = 4'b1101;
    localparam CON = 4'b1110;
    localparam NOP = 4'b1111;
    
    sequencer i_sequencer (
        .clk(clk),
        .reset(reset),
        .comp(sequencer_com),
        .cycle_data(cycle_data)
    );
    
    always @(*) begin
        flag_en = 1'b0;
        alu_to_reg = 1'b0;
        mem_to_reg = 1'b0;
        reg_to_pc = 1'b0;
        reg_to_mem = 1'b0;
        pc_to_srr = 1'b0;
        srr_to_pc = 1'b0;
        in_to_reg = 1'b0;
        reg_to_out = 1'b0;
        reg_to_reg = 1'b0;
        pc_to_reg = 1'b0;
        ir_to_reg = 1'b0;
        prog_to_reg = 1'b0;
        sequencer_com = 1'b0;
        pc_next = 1'b0;
        
        reg_addr_a = 4'b0;
        reg_addr_b = 4'b0;
        reg_addr_w = 4'b0;
        alu_op = 3'b0;
        mem_addr = 16'b0;
        
        if (con_active) begin
            prog_to_reg = 1'b1;
            reg_addr_w = con_dest;
            sequencer_com = 1'b1;
        end else begin
            case (ir_out[15:12])
                ADD: begin
                    flag_en = 1'b1;
                    alu_to_reg = 1'b1;
                    reg_addr_a = ir_out[11:8];
                    reg_addr_b = ir_out[7:4];
                    reg_addr_w = ir_out[3:0];
                    alu_op = 3'b000;
                    sequencer_com = 1'b1;
                end
                
                SUB: begin
                    flag_en = 1'b1;
                    alu_to_reg = 1'b1;
                    reg_addr_a = ir_out[11:8];
                    reg_addr_b = ir_out[7:4];
                    reg_addr_w = ir_out[3:0];
                    alu_op = 3'b001;
                    sequencer_com = 1'b1;
                end
                
                LOG: begin
                    flag_en = ir_out[11];
                    alu_to_reg = 1'b1;
                    reg_addr_a = ir_out[3:0];
                    reg_addr_b = ir_out[7:4];
                    reg_addr_w = ir_out[7:4];
                    alu_op = ir_out[10:8];
                    sequencer_com = 1'b1;
                end
                
                JMP: begin
                    if (&(~ir_out[11:8] | flags)) begin
                        reg_addr_a = ir_out[7:4];
                        reg_to_pc = 1'b1;
                    end
                    sequencer_com = 1'b1;
                end
                
                JTS: begin
                    if (cycle_data == 3'b000) begin
                        pc_to_srr = 1'b1;
                    end else begin
                        reg_addr_a = ir_out[7:4];
                        reg_to_pc = 1'b1;
                        sequencer_com = 1'b1;
                    end
                end
                
                RET: begin
                    srr_to_pc = 1'b1;
                    sequencer_com = 1'b1;
                end
                
                LD: begin
                    if (cycle_data == 3'b000) begin
                        mem_addr = {8'b000000000, ir_out[11:4]};
                    end else begin
                        mem_addr = {8'b000000000, ir_out[11:4]};
                        mem_to_reg = 1'b1;
                        reg_addr_w = ir_out[3:0];
                        sequencer_com = 1'b1;
                    end
                end
                
                LDR: begin
                    if (cycle_data == 3'b000) begin
                        reg_addr_a = ir_out[11:8];
                        reg_addr_b = ir_out[7:4];
                        mem_addr = reg_out_a + reg_out_b;
                    end else begin
                        mem_to_reg = 1'b1;
                        reg_addr_a = ir_out[11:8];
                        reg_addr_b = ir_out[7:4];
                        reg_addr_w = ir_out[3:0];
                        mem_addr = reg_out_a + reg_out_b;
                        sequencer_com = 1'b1;
                    end
                end
                
                ST: begin
                    reg_to_mem = 1'b1;
                    mem_addr = {8'b000000000, ir_out[11:4]};
                    reg_addr_a = ir_out[3:0];
                    sequencer_com = 1'b1;
                end
                
                STR: begin
                    if (cycle_data == 3'b000) begin
                        reg_addr_a = ir_out[11:8];
                        reg_addr_b = ir_out[7:4];
                    end else begin
                        reg_to_mem = 1'b1;
                        reg_addr_a = ir_out[3:0];
                        mem_addr = temp_mem_addr;
                        sequencer_com = 1'b1;
                    end
                end
                
                IN: begin
                    in_to_reg = 1'b1;
                    reg_addr_w = ir_out[3:0];
                    sequencer_com = 1'b1;
                end
                
                OUT: begin
                    reg_to_out = 1'b1;
                    reg_addr_a = ir_out[3:0];
                    sequencer_com = 1'b1;
                end
                
                MOV: begin
                    reg_to_reg = 1'b1;
                    reg_addr_a = ir_out[11:8];
                    reg_addr_w = ir_out[3:0];
                    sequencer_com = 1'b1;
                end
                
                CON: begin
                    pc_next = 1'b1;
                end
                
                
                default: begin
                    sequencer_com = 1'b1;
                end
            endcase
        end
    end
    
    always @(posedge clk) begin
        if (ir_out[15:12] == STR && cycle_data == 3'b000) begin
            temp_mem_addr <= reg_out_a + reg_out_b;
        end
        
        if (ir_out[15:12] == CON && cycle_data == 3'b000) begin
            con_dest <= ir_out[3:0];
            con_active <= 1'b1;
        end else begin
            con_active <= 1'b0;
        end
    end
    
endmodule
