module pc #(
    parameter addr_width
)(
    input clk,
    input hold,
    input reset,
    input jmp_enable,
    input [addr_width-1:0] jmp_addr,

    output reg [addr_width-1:0] inc_addr,
    output logic [addr_width-1:0] next_addr
);
    always @(*) begin
        next_addr = inc_addr;
        if(jmp_enable)
            next_addr = jmp_addr;
        if(hold)
            next_addr = inc_addr - 1;
        if(reset)
            next_addr = 0;
    end

    always @(posedge clk) begin
        inc_addr <= next_addr + 1;
        if(reset)
            inc_addr <= 0;
    end

endmodule
