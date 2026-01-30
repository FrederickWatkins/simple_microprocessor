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
    output logic [1:0] bus_0_sel,
    output logic [1:0] bus_1_sel,

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
    output logic jmp_enable,
    output logic hold,

    // Instruction memory control
    output logic instr_we,

    // Main memory control
    output logic mm_we,

    // Reprogramming controls
    output logic reset
);
    // Opcodes
    localparam nop = 'b0000;

    localparam call = 'b0001;
    localparam jmp = 'b0010;
    localparam jmpne = 'b0011;
    localparam lw = 'b0100;
    localparam sw = 'b0101;
    localparam le = 'b0110;
    localparam move = 'b0111;

    localparam arithmetic = 'b1zzz;

    // Reprogamming values
    localparam reprog_mm = 'b01;
    localparam reprog_instr = 'b10;
    localparam reprog_reset = 'b11;

    wire [opcode_width-1:0] opcode;
    
    assign opcode = instr[opcode_width-1:0];
    assign rs_addr = instr[opcode_width+reg_addr_width-1:opcode_width];
    assign rd_addr = instr[opcode_width+reg_addr_width*2-1:opcode_width+reg_addr_width];
    assign imm = instr[instr_width-1:opcode_width+reg_addr_width*2];

    assign alu_opcode = opcode[2:0];

    reg prev_hold;

    always @(*) begin
        bus_0_sel = 0;
        bus_1_sel = 0;
        if(rs_addr==0)
            bus_1_sel = 1; // Use imm if rs is r0
        rd_we = 0;
        rd_in_sel = select_bus_0;
        jmp_enable = 0;
        instr_we = 0;
        mm_we = 0;
        reset = 0;
        hold = 0;
        casez(opcode)
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
            hold = 1;
            if(prev_hold == 1)
                bus_0_sel = 1;
                rd_we = 1; 
        end
        sw: begin
            mm_we = 1;
        end
        le: begin
            // Unimplemented TODO: Add equal flag
        end
        move: begin
            rd_we = 1;
            rd_in_sel = select_bus_1;
        end
        arithmetic: begin
            rd_we = 1;
            rd_in_sel = select_alu;
        end
        endcase
        if(prev_hold)
            hold = 0;
        
        // Reprogramming/reset
        case(reprog)
        reprog_mm: begin
            reset = 1;
            mm_we = 1;
            bus_0_sel = 2;
            bus_1_sel = 2;
        end
        reprog_instr: begin
            reset = 1;
            instr_we = 1;
        end
        reprog_reset: begin
            reset = 1;
        end
        endcase
    end

    always @(posedge clk) begin
        prev_hold <= hold;
    end
endmodule
