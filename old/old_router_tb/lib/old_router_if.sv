interface router_if(input bit clk);
    logic [0:`PL-1] inputs[0:`REN-1];
    logic [0:`PL-1] outputs[0:`REN-1];
    logic signals_in[0:`REN-1];
    logic signals_out[0:`REN-1];
endinterface