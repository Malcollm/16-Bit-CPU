`timescale 1ns / 1ps

module core_tb;
    reg clk;
    reg reset;
    
    reg [15:0] inputs;
    wire [15:0] outputs;
    
    core i_core(
        .clk(clk),
        .reset(reset),
        .in_in(inputs),
        .out_out(outputs)
    );
    
    initial begin
        reset = 1'b1;
        
        repeat (3) @(posedge clk);
        
        reset = 1'b0;
        inputs = 16'h0000;
        #200
        inputs = 16'h0004;
        #200
        inputs = 16'h0002;
        
        repeat (70) @(posedge clk);
        
        $finish;
    end
    
    initial clk = 1'b0;
    always #100 clk = ~clk;
    
endmodule
