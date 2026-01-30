`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2026 09:54:00 PM
// Design Name: 
// Module Name: control_unit
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


module control_unit #(
    parameter opcode_width = 4,
    parameter reg_addr_width = 2,
    parameter instr_width = 16,
    parameter data_width = 8
)
(
        input clk,
        input reprog,
        input [instr_width-1:0] instr,

        output [1:0] select_src,
        output [1:0] select_dest,

        output [reg_addr_width-1:0] src_reg,
        output [reg_addr_width-1:0] dest_reg,

        output mm_we,
        output [data_width-1:0] mm_read_addr,
        output [data_width-1:0] mm_write_addr
);
endmodule
