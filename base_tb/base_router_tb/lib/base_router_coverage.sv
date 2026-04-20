class base_router_coverage #(parameter DATA_WIDTH = 32, NUM_PORTS=4) extends uvm_subscriber #(base_router_item#(DATA_WIDTH, NUM_PORTS));
    `uvm_component_param_utils(base_router_coverage#(DATA_WIDTH, NUM_PORTS))

    logic [NUM_PORTS-1:0] valid;
    int port;
    bit is_input;
    int destination;

    covergroup base_router_cg;
        coverpoint port {
            bins port_array[NUM_PORTS] = {[0:NUM_PORTS-1]};
        }
        coverpoint destination {
            bins dest_array[] = {[0:base_cfg.ROUTERS_NUM-1]};
        }
        coverpoint is_input {
            bins inp = {1};
            bins outp = {0};
        }
        func_cov: cross destination, port, is_input;
    endgroup

    base_router_config base_cfg;

    function new(string name = "base_router_coverage", uvm_component parent = null);
        super.new(name, parent);
        if(!uvm_config_db#(base_router_config)::get(null, "", "base_cfg", base_cfg)) `uvm_fatal("CONFIG", "Component was not properly configured");
        base_router_cg = new();
    endfunction
    
    virtual function void write(base_router_item#(DATA_WIDTH, NUM_PORTS) t);
        is_input = t.is_input;
        foreach(t.ports[i]) begin
            if(t.ports[i].valid && t.ports[i].ready)
            port = i;
            destination = t.ports[i].destination;
            base_router_cg.sample();
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("COV", $sformatf("Base coverage: %.2f%%", base_router_cg.func_cov.get_coverage()), UVM_LOW)
    endfunction
endclass