interface noc_if(input bit clk);
`ifdef MESH_TORUS
    logic [0:`PL-1] core_inputs[0:`Y-1][0:`X-1];
    logic [0:`PL-1] core_outputs[0:`Y-1][0:`X-1];
    logic core_availability_signals_in[0:`Y-1][0:`X-1];
    logic core_availability_signals_out[0:`Y-1][0:`X-1];
`elsif CIRCULANT
    logic [0:`PL-1] core_inputs[0:`RN-1];
    logic [0:`PL-1] core_outputs[0:`RN-1];
    logic core_availability_signals_in[0:`RN-1];
    logic core_availability_signals_out[0:`RN-1];
`endif
endinterface