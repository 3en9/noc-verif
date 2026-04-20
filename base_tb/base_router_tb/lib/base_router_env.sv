
class base_router_env #(parameter DATA_WIDTH = 32, NUM_PORTS=4) extends uvm_env;
    `uvm_component_param_utils(base_router_env#(DATA_WIDTH, NUM_PORTS))

    base_router_agent      #(DATA_WIDTH, NUM_PORTS)  agent;
    base_router_scoreboard #(DATA_WIDTH, NUM_PORTS)  scoreboard;
    base_router_coverage   #(DATA_WIDTH, NUM_PORTS)  coverage;
    
    function new(string name = "base_router_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = base_router_agent#(DATA_WIDTH, NUM_PORTS)::type_id::create("agent", this);
        scoreboard = base_router_scoreboard#(DATA_WIDTH, NUM_PORTS)::type_id::create("scoreboard", this);
        coverage = base_router_coverage#(DATA_WIDTH, NUM_PORTS)::type_id::create("coverage", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.monitor.mon_analysis_port.connect(scoreboard.analysis_export);
        agent.monitor.mon_analysis_port.connect(coverage.analysis_export);
    endfunction
endclass