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
    parameter data_width = 8,
    parameter select_bus_0 = 'b00,
    parameter select_bus_1 = 'b01,
    parameter select_alu = 'b10,
    parameter select_pc = 'b11
)
(
    input clk,
    input [1:0] reprog,
    input [instr_width-1:0] instr,

    // Bus control
    output logic bus_0_sel,
    output logic bus_1_sel,

    // Register file control
    output logic rd_we,
    output logic [1:0] rd_in_sel,
    output [reg_addr_width-1:0] rs_addr,
    output [reg_addr_width-1:0] rd_addr,

    // Immediate value
    output [data_width-1:0] imm,

    // ALU control
    output [2:0] alu_opcode,

    // Program counter control
    output logic jmp_enable
);
    localparam nop = 'b0000;

    localparam call = 'b0001;
    localparam jmp = 'b0010;
    localparam jmpne = 'b0011;
    localparam lw = 'b0100;
    localparam sw = 'b0101;
    localparam le = 'b0110;
    localparam move = 'b0111;

    localparam arithmetic = 'b1xxx;

    wire [opcode_width-1:0] opcode;
    
    assign opcode = instr[opcode_width-1:0];
    assign rs_addr = instr[opcode_width+reg_addr_width-1:opcode_width];
    assign rd_addr = instr[opcode_width+reg_addr_width*2-1:opcode_width+reg_addr_width];
    assign imm = instr[instr_width-1:opcode_width+reg_addr_width*2];

    assign alu_opcode = opcode[2:0];

    // Use imm if rs is r0
    always @(*) begin
        bus_1_sel = 0;
        if(rs_addr==0)
            bus_1_sel = 1;
    end

    always @(*) begin
        bus_0_sel = 0;
        rd_we = 0;
        rd_in_sel = select_bus_0;
        jmp_enable = 0;
        case(opcode)
        nop: begin end

        call: begin
            rd_we = 1;
            rd_in_sel = select_pc;
            jmp_enable = 1;
        end
        jmp: begin
            jmp_enable = 1;
        end
        jmpne: begin
            // Unimplemented TODO: Add equal flag
        end
        lw: begin
            // Unimplemented TODO: Add main memory
        end
        sw: begin
            // Unimplemented TODO: Add main memory
        end
        le: begin
            // Unimplemented TODO: Add equal flag
        end
        move: begin
            rd_we = 1;
            rd_in_sel = select_bus_1;
        end
        endcase
    end
endmodule
