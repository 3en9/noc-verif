class base_router_agent#(parameter DATA_WIDTH = 32, NUM_PORTS=4) extends uvm_agent;
    `uvm_component_param_utils(base_router_agent#(DATA_WIDTH, NUM_PORTS))

    base_router_sequencer #(DATA_WIDTH, NUM_PORTS) sequencer;
    base_router_driver #(DATA_WIDTH, NUM_PORTS)    driver;
    base_router_monitor #(DATA_WIDTH, NUM_PORTS)   monitor;
    
    function new(string name = "base_router_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = base_router_monitor#(DATA_WIDTH, NUM_PORTS)::type_id::create("monitor", this);
        sequencer = base_router_sequencer#(DATA_WIDTH, NUM_PORTS)::type_id::create("sequencer", this);
        driver = base_router_driver#(DATA_WIDTH, NUM_PORTS)::type_id::create("driver", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass