class base_router_driver #(parameter DATA_WIDTH = 32, NUM_PORTS=4) extends uvm_driver #(base_router_item#(DATA_WIDTH, NUM_PORTS));
    `uvm_component_param_utils(base_router_driver#(DATA_WIDTH, NUM_PORTS))
    function new(string name = "base_router_driver", uvm_component parent = null);
        super.new(name, parent);
        if(!uvm_config_db#(base_router_config)::get(null, "", "base_cfg", base_cfg)) `uvm_fatal("CONFIG", "Component was not properly configured");
    endfunction

    base_router_config base_cfg;
    
    virtual task run_phase(uvm_phase phase);
        `uvm_fatal("DRV_IMPL", "run_phase must be overridden in derived class")
    endtask
endclass