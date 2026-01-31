`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/30/2026 03:10:38 PM
// Design Name: 
// Module Name: processor_tb1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module processor_tb1(

    );
    reg clk = 0;

    reg [1:0] reprog;
    reg [8-1:0] reprog_addr;
    reg [16-1:0] reprog_data;

    reg [16-1:0] prog_mem [(1<<8)-1:0];
    reg [8-1:0] main_mem [(1<<8)-1:0];

    reg [16-1:0] i = 0;

    processor processor_0 (
        .clk(clk),
        .reprog(reprog),
        .reprog_addr(reprog_addr),
        .reprog_data(reprog_data)
    );
    always
        #50 clk = ~clk;
        initial begin
            $readmemh("prog.mem", prog_mem);
            $readmemh("data.mem", main_mem);
            while(i < 1<<8) begin
                reprog_addr = i;
                reprog_data = prog_mem[i];
                reprog = 'b10;
                i <= i + 1;
                #100;
            end
            i = 0;
            while(i < 1<<8) begin
                reprog_addr = i;
                reprog_data = main_mem[i];
                reprog = 'b01;
                i <= i + 1;
                #100;
            end
            reprog = 'b00;
            reprog_addr = 0;
            reprog_data = 0;
            $stop;
        end
endmodule
