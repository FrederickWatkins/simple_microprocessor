module ram #(
    parameter addr_width = 8,
    parameter data_width = 8
)(
    input  wire        clk,
    input  wire        write_enable,
    
    // Write Port
    input  wire [addr_width-1:0]  write_addr,
    input  wire [data_width-1:0] write_data,
    
    // Read Port
    input  wire [addr_width-1:0]  read_addr,
    output wire [data_width-1:0] read_data
);

    reg [data_width-1:0] ram [(1<<addr_width)-1:0];

    // Synchronous Write: Data is stored on the rising edge
    always @(posedge clk) begin
        if (write_enable) begin
            ram[write_addr] <= write_data;
        end
    end

    // Asynchronous Read: Output changes immediately when read_addr changes
    assign read_data = ram[read_addr];

endmodule