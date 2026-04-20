class base_router_monitor #(parameter DATA_WIDTH = 32, NUM_PORTS=4) extends uvm_monitor;
    `uvm_component_param_utils(base_router_monitor#(DATA_WIDTH, NUM_PORTS))
    function new(string name = "base_router_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    uvm_analysis_port #(base_router_item#(DATA_WIDTH, NUM_PORTS)) mon_analysis_port;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_analysis_port = new ("mon_analysis_port", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        `uvm_fatal("MON_IMPL", "run_phase must be overridden in derived class")
    endtask
endclass