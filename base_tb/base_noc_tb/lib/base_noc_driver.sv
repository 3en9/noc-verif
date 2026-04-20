class base_noc_driver #(parameter DATA_WIDTH = 32, ROUTERS_NUM=4) extends uvm_driver #(base_noc_item#(DATA_WIDTH, ROUTERS_NUM));
    `uvm_component_param_utils(base_noc_driver#(DATA_WIDTH, ROUTERS_NUM))
    function new(string name = "base_noc_driver", uvm_component parent = null);
        super.new(name, parent);
        if(!uvm_config_db#(base_noc_config)::get(null, "", "base_cfg", base_cfg)) `uvm_fatal("CONFIG", "Component was not properly configured");;
    endfunction

    base_noc_config base_cfg;
    
    virtual task run_phase(uvm_phase phase);
        `uvm_fatal("DRV_IMPL", "run_phase must be overridden in derived class")
    endtask
endclass