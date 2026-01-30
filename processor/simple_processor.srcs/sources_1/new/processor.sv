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
    // Programming interface
    input [1:0] reprog,
    input [data_width-1:0] reprog_addr,
    input [instr_width-1:0] reprog_data
    );
    localparam opcode_width = 4; // 16 instructions
    localparam reg_addr_width = 2; // 4 registers
    localparam data_width = 8; // Same as main memory address width
    localparam instr_width = opcode_width + 2 * reg_addr_width + data_width;

    wire reset;

    // Bus 0
    wire bus_0_sel;
    wire [data_width-1:0] bus_0_inputs [2:0];
    wire [data_width-1:0] bus_0_output;

    assign bus_0_inputs[2] = reprog_data;

    bus #(
        .data_width(data_width),
        .input_depth(2)
    ) bus_0 (
        .input_selector(bus_0_sel),
        .data_in(bus_0_inputs),
        .data_out(bus_0_output)
    );

    // Bus 1
    wire bus_1_sel;
    wire [data_width-1:0] bus_1_inputs [2:0];
    wire [data_width-1:0] bus_1_output;

    assign bus_1_inputs[2] = reprog_addr;

    bus #(
        .data_width(data_width),
        .input_depth(2)
    ) bus_1 (
        .input_selector(bus_1_sel),
        .data_in(bus_1_inputs),
        .data_out(bus_1_output)
    );

    // Register file
    wire [reg_addr_width-1:0] rs_addr;
    wire [data_width-1:0] rs;
    wire rd_we;
    wire [1:0] rd_in_sel;
    wire [reg_addr_width-1:0] rd_addr;
    reg [data_width-1:0] rd_in;
    wire [data_width-1:0] rd_out;

    assign bus_0_inputs[0] = rs;

    assign bus_1_inputs[0] = rd_out;

    localparam select_bus_0 = 'b00;
    localparam select_bus_1 = 'b01;
    localparam select_alu = 'b10;
    localparam select_pc = 'b11;

    always @(*) begin
        rd_in = 0;
        case(rd_in_sel)
        select_bus_0: rd_in = bus_0_output;
        select_bus_1: rd_in = bus_1_output;
        select_alu: rd_in = alu_res;
        select_pc: rd_in = pc_inc_addr;
        endcase
    end

    rams_dist #(
        .addr_width(reg_addr_width),
        .data_width(data_width)
    ) reg_file (
        .clk(clk),
        .reset(reset),
        .write_enable(rd_we),

        .read_addr(rs_addr),
        .read_data(rs),

        .rw_addr(rd_addr),
        .rw_data_in(rd_in),
        .rw_data_out(rd_out)
    );

    // ALU
    wire [2:0] alu_opcode;
    wire [data_width-1:0] alu_res;

    alu #(
        .data_width(data_width)
    ) alu_0 (
        .clk(clk),
        .operator(alu_opcode),
        .operand_0(bus_0_output),
        .operand_1(bus_1_output),
        .result(alu_res)
    );

    // Control unit
    wire [instr_width-1:0] curr_instr;
    wire [data_width-1:0] cu_imm;
    wire hold;
    wire jmp_enable;

    assign bus_1_inputs[1] = cu_imm;
    control_unit #(
        .opcode_width(opcode_width),
        .reg_addr_width(reg_addr_width),
        .instr_width(instr_width),
        .data_width(data_width),
        .select_bus_0(select_bus_0),
        .select_bus_1(select_bus_1),
        .select_alu(select_alu),
        .select_pc(select_pc)
    ) control_unit_0 (
        .clk(clk),
        .reprog(reprog),
        .instr(curr_instr),

        .bus_0_sel(bus_0_sel),
        .bus_1_sel(bus_1_sel),

        .rd_we(rd_we),
        .rd_in_sel(rd_in_sel),
        .rs_addr(rs_addr),
        .rd_addr(rd_addr),

        .imm(cu_imm),

        .alu_opcode(alu_opcode),

        .hold(hold),
        .jmp_enable(jmp_enable),

        .instr_we(instr_we),

        .mm_we(mm_we),

        .reset(reset)
    );

    // Program counter
    wire [data_width-1:0] pc_inc_addr;
    wire [data_width-1:0] pc_next_addr;

    pc #(
        .addr_width(data_width)
    ) pc_0 (
        .clk(clk),
        .reset(reset),
        .hold(hold),

        .jmp_enable(jmp_enable),
        .jmp_addr(bus_1_output),

        .inc_addr(pc_inc_addr),
        .next_addr(pc_next_addr)
    );

    // Instruction memory
    wire instr_we;
    sync_ram #(
        .addr_width(data_width),
        .data_width(instr_width)
    ) instr_mem (
        .clk(clk),
        .write_enable(instr_we),

        .write_addr(reprog_addr),
        .write_data(reprog_data),

        .read_addr(pc_next_addr),
        .read_data(curr_instr)
    );

    // Main memory
    wire mm_we;
    sync_ram #(
        .addr_width(data_width),
        .data_width(data_width)
    ) main_mem (
        .clk(clk),
        .write_enable(mm_we),

        .write_addr(bus_1_output),
        .write_data(bus_0_output),

        .read_addr(bus_1_output),
        .read_data(bus_0_inputs[1])
    );
endmodule
