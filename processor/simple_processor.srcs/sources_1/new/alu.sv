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
    output logic zero,
    output logic [data_width-1:0] result
);
    // Operators

    localparam add = 'b000;
    localparam sub = 'b001;
    localparam rr = 'b010;
    localparam rl = 'b011;
    localparam mul = 'b100;
    localparam div = 'b101;
    localparam rem = 'b110;

    always @(*)
    begin
        zero = 0;
        case(operator)
        add: result = operand_0 + operand_1;
        sub: result = operand_0 - operand_1;
        rr: result = operand_0 >> operand_1;
        rl: result = operand_0 << operand_1;
        mul: result = operand_0 * operand_1;
        div: result = operand_0 / operand_1;
        rem: result = operand_0 % operand_1;
        default: result = operand_0;
        endcase
        if(result == 0)
            zero = 1;
    end
endmodule
