`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/29/2026 08:20:25 PM
// Design Name: 
// Module Name: processor
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


module processor (
    input clk,
    input reprog,
    input [data_width-1:0] instr_addr,
    input [instr_width-1:0] instr_in
    );
    localparam opcode_width = 4; // 16 instructions
    localparam reg_addr_width = 2; // 4 registers
    localparam data_width = 8; // Same as main memory address width
    localparam instr_width = opcode_width + 2 * reg_addr_width + data_width;

    localparam select_reg = 'b00;
    localparam select_mm = 'b01;
    localparam select_alu = 'b10;

    // Main bus
    wire [1:0] select_src;
    wire [1:0] select_dest;
    reg [data_width-1:0] main_bus;

    always @(*) begin
        main_bus = 0;
        reg_data_in = 0;
        mm_data_in = 0;
        alu_const_operand = 0;
        case(select_src)
            select_reg: main_bus = reg_data_out;
            select_mm: main_bus = mm_data_out;
            select_alu: main_bus = alu_result;
        endcase
        case(select_dest)
            select_reg: reg_data_in = main_bus;
            select_mm: mm_data_in = main_bus;
            select_alu: alu_const_operand = main_bus;
        endcase
    end

    // Control unit
    control_unit #(
        .opcode_width(opcode_width),
        .reg_addr_width(reg_addr_width),
        .instr_width(instr_width),
        .data_width(data_width)
    ) control_unit_0 (
        .clk(clk),
        .reprog(reprog),
        .instr(instr_out),

        .select_src(select_src),
        .select_dest(select_dest),

        .src_reg(src_reg),
        .dest_reg(dest_reg),

        .mm_we(mm_we),
        .mm_read_addr(mm_read_addr),
        .mm_write_addr(mm_write_addr)
    );

    // Register file
    wire [reg_addr_width-1:0] src_reg;
    wire [reg_addr_width-1:0] dest_reg;
    wire [data_width-1:0] reg_data_out;
    reg [data_width-1:0] reg_data_in;
    wire reg_we;

    ram #(
        .addr_width(reg_addr_width),
        .data_width(data_width)
    ) register_file (
        .clk(clk),
        .write_enable(reg_we),

        .read_addr(src_reg),
        .read_data(reg_data_out),

        .write_addr(dest_reg),
        .write_data(reg_data_in)
    );


    // Main memory
    wire mm_we;
    wire [data_width-1:0] mm_write_addr;
    reg [data_width-1:0] mm_data_in;
    wire [data_width-1:0] mm_read_addr;
    wire [data_width-1:0] mm_data_out;

    sync_ram #(
        .addr_width(data_width),
        .data_width(data_width)
    ) main_memory (
        .clk(clk),
        .write_enable(mm_we),

        .read_addr(mm_read_addr),
        .read_data(mm_data_out),

        .write_addr(mm_write_addr),
        .write_data(mm_data_in)
    );

    // Instruction memory
    wire [data_width-1:0] instr_cntr;
    wire [instr_width-1:0] instr_out;

    sync_ram #(
        .addr_width(data_width),
        .data_width(instr_width)
    ) instr_mem (
        .clk(clk),
        .write_enable(reprog),

        .read_addr(instr_cntr),
        .read_data(instr_out),

        .write_addr(instr_addr),
        .write_data(instr_in)
    );

    // ALU
    wire [2:0] alu_operator;
    reg [data_width-1:0] alu_const_operand;
    wire [data_width-1:0] alu_result;

    alu #(
        .data_width(data_width)
    ) alu_0 (
        .clk(clk),
        .operator(alu_operator),
        .operand_1(read_data),
        .operand_2(alu_const_operand),
        .result(alu_result)
    );
endmodule
