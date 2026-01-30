module bus #(
    parameter data_width = 8,
    parameter input_depth = 1
)(
    input [input_depth-1:0] input_selector,
    input [data_width-1:0] data_in [1<<input_depth-1:0],

    output [data_width-1:0] data_out
);
    assign data_out = data_in[input_selector];
endmodule