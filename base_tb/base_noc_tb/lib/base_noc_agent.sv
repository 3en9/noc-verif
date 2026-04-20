class base_noc_agent#(parameter DATA_WIDTH = 32, ROUTERS_NUM=16) extends uvm_agent;
    `uvm_component_param_utils(base_noc_agent#(DATA_WIDTH, ROUTERS_NUM))

    base_noc_sequencer #(DATA_WIDTH, ROUTERS_NUM) sequencer;
    base_noc_driver #(DATA_WIDTH, ROUTERS_NUM)    driver;
    base_noc_monitor #(DATA_WIDTH, ROUTERS_NUM)   monitor;
    
    function new(string name = "base_noc_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = base_noc_monitor#(DATA_WIDTH, ROUTERS_NUM)::type_id::create("monitor", this);
        sequencer = base_noc_sequencer#(DATA_WIDTH, ROUTERS_NUM)::type_id::create("sequencer", this);
        driver = base_noc_driver#(DATA_WIDTH, ROUTERS_NUM)::type_id::create("driver", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass