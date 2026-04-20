class base_noc_monitor #(parameter DATA_WIDTH = 32, ROUTERS_NUM=16) extends uvm_monitor;
    `uvm_component_param_utils(base_noc_monitor#(DATA_WIDTH, ROUTERS_NUM))
    function new(string name = "base_noc_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    uvm_analysis_port #(base_noc_item#(DATA_WIDTH, ROUTERS_NUM)) mon_analysis_port;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_analysis_port = new ("mon_analysis_port", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        `uvm_fatal("MON_IMPL", "run_phase must be overridden in derived class")
    endtask
endclass