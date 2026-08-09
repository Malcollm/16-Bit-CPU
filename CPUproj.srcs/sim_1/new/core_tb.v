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
        
        repeat (40) @(posedge clk);
        
        $finish;
    end
    
    always #5 clk = ~clk;
    
endmodule
