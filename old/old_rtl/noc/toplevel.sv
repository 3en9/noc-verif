`include "inc/noc.svh"
`include "inc/noc_XY.svh"
`include "noc/noc.sv"


module toplevel (
    input clk,
    input[0:`PL-1] packet,
    input[`CS-1:0] core_X,
    input[`CS-1:0] core_Y,
    input core_availability_signals_out[0:`Y-1][0:`X-1],
    output core_availability_signals_in[0:`Y-1][0:`X-1],
    output wire[0:1] core_inputs_2_bits[0:`Y-1][0:`X-1]
);

    wire[0:`PL-1] core_inputs[0:`Y-1][0:`X-1];
    wire[0:`PL-1] core_outputs[0:`Y-1][0:`X-1];

    generate
        genvar i, j;

        for (i = 0; i < `Y; i = i + 1)
        begin : bool_grid_Y
            for (j = 0; j < `X; j = j + 1)
            begin : bool_grid_X
                assign core_inputs_2_bits[i][j] = {core_inputs[i][j][0], ^core_inputs[i][j]};
            end
        end

    endgenerate

    dataSelector selector(.clk(clk), .packet(packet), .core_X(core_X), .core_Y(core_Y), .core_outputs(core_outputs));

    noc noc(
        .clk(clk),
        .core_inputs(core_inputs),
        .core_outputs(core_outputs),
        .core_availability_signals_out(core_availability_signals_out),
        .core_availability_signals_in(core_availability_signals_in)
    );
    
endmodule


module dataSelector (
    input clk,
    input[0:`PL-1] packet,
    input[`CS-1:0] core_X,
    input[`CS-1:0] core_Y,
    output reg[0:`PL-1] core_outputs[0:`Y-1][0:`X-1]
);

	initial begin
        int i, j;
        for (i = 0; i < `Y; i = i + 1)
        begin
            for (j = 0; j < `X; j = j + 1)
            begin
                core_outputs[i][j] = 0;
            end
        end
    end
    
    always @(posedge clk) begin
        core_outputs[core_Y][core_X] <= packet;
    end
    
endmodule