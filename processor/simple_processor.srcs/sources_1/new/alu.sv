`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2026 09:32:52 PM
// Design Name: 
// Module Name: alu
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


module alu #(
    parameter data_width = 8
)(
    input [2:0] operator,
    input [data_width-1:0] operand_0,
    input [data_width-1:0] operand_1,
    output logic [data_width-1:0] result
);
    // Operators

    localparam add = 'b000;
    localparam sub = 'b001;
    localparam rr = 'b010;
    localparam rl = 'b011;

    always @(*)
    begin
        case(operator)
        add: result = operand_0 + operand_1;
        sub: result = operand_0 - operand_1;
        rr: result = operand_0 >> operand_1;
        rl: result = operand_0 << operand_1;
        default: result = operand_0;
        endcase
    end
endmodule
