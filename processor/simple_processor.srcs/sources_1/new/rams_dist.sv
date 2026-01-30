module rams_dist #(
    parameter addr_width = 8,
    parameter data_width = 8
)(
    input  wire        clk,
    input  wire        write_enable,
    
    
    // Read Port
    input  wire [addr_width-1:0]  read_addr,
    output wire [data_width-1:0] read_data,

    // Read/write Port
    input  wire [addr_width-1:0]  rw_addr,
    input  wire [data_width-1:0] rw_data_in,
    output wire [data_width-1:0] rw_data_out
);

    reg [data_width:0] ram [(1<<addr_width)-1:0];

    assign ram[0] = 0;

    // Synchronous Write: Data is stored on the rising edge
    always @(posedge clk) begin
        if (write_enable & rw_addr != 0) begin
            ram[rw_addr] <= rw_data_in;
        end
    end

    // Asynchronous Read: Output changes immediately when read_addr changes
    assign read_data = ram[read_addr];
    assign rw_data_out = ram[rw_addr];

endmodule