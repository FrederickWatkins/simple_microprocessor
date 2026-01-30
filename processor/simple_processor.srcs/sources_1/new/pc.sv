module pc #(
    parameter addr_width
)(
    input clk,
    input jmp_enable,
    input [addr_width-1:0] jmp_addr,

    output reg [addr_width-1:0] inc_addr,
    output [addr_width-1:0] next_addr
);
    assign next_addr = jmp_enable?jmp_addr:inc_addr;

    always @(posedge clk) begin
        inc_addr <= next_addr + 1;
    end

endmodule
