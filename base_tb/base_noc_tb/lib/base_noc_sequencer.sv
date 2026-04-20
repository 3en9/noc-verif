class base_noc_sequencer #(parameter DATA_WIDTH = 32, ROUTERS_NUM=16) extends uvm_sequencer#(base_noc_item#(DATA_WIDTH, ROUTERS_NUM));
    function new(string name = "base_noc_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    `uvm_component_param_utils(base_noc_sequencer#(DATA_WIDTH, ROUTERS_NUM))
endclass