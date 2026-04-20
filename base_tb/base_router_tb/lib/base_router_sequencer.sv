class base_router_sequencer #(parameter DATA_WIDTH = 32, NUM_PORTS=4) extends uvm_sequencer#(base_router_item#(DATA_WIDTH, NUM_PORTS));
    function new(string name = "base_router_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    `uvm_component_param_utils(base_router_sequencer#(DATA_WIDTH, NUM_PORTS))
endclass