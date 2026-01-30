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

    reg [8-1:0] i = 0;

    processor processor_0 (
        .clk(clk),
        .reprog(reprog),
        .reprog_addr(reprog_addr),
        .reprog_data(reprog_data)
    );
    always
        #50 clk = ~clk;
        initial begin
            while(1) begin
                reprog_addr = i;
                case(i)
                3: reprog_data = 'b00000101_01_00_0111; // Load 5 in r1
                4: reprog_data = 'b00000010_10_00_0111; // Load 2 in r2
                5: reprog_data = 'b00001010_00_00_0010; // Jump 10
                15: reprog_data = 'b00000000_01_10_1000; // Add r2 to r1 store in r1
                16: reprog_data = 'b00000011_01_00_0101; // Store r1 in address 3
                17: reprog_data = 'b00000000_01_10_0111; // Move r1 to r2
                18: reprog_data = 'b00000011_01_00_0100; // Load r1 from address 3
                19: reprog_data = 'b00001111_00_00_0010; // Jump 15
                default: reprog_data = 'b00000000_00_00_0000;
                endcase
                if(i < 20)
                begin
                    reprog = 'b10;
                    i <= i + 1;
                end
                else begin
                    reprog = 'b00;
                    reprog_addr = 0;
                    reprog_data = 0;
                end
                #100;
            end
        end
endmodule
