
class base_noc_env #(parameter DATA_WIDTH = 32, ROUTERS_NUM=16) extends uvm_env;
    `uvm_component_param_utils(base_noc_env#(DATA_WIDTH, ROUTERS_NUM))

    base_noc_agent      #(DATA_WIDTH, ROUTERS_NUM)  agent;
    base_noc_scoreboard #(DATA_WIDTH, ROUTERS_NUM)  scoreboard;
    base_noc_coverage   #(DATA_WIDTH, ROUTERS_NUM)  coverage;
    
    function new(string name = "base_noc_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = base_noc_agent#(DATA_WIDTH, ROUTERS_NUM)::type_id::create("agent", this);
        scoreboard = base_noc_scoreboard#(DATA_WIDTH, ROUTERS_NUM)::type_id::create("scoreboard", this);
        coverage = base_noc_coverage#(DATA_WIDTH, ROUTERS_NUM)::type_id::create("coverage", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.monitor.mon_analysis_port.connect(scoreboard.analysis_export);
        agent.monitor.mon_analysis_port.connect(coverage.analysis_export);
    endfunction
endclass