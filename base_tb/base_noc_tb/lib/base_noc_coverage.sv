class base_noc_coverage #(parameter DATA_WIDTH = 32, ROUTERS_NUM = 16) extends uvm_subscriber #(base_noc_item #(DATA_WIDTH, ROUTERS_NUM));
    
    `uvm_component_param_utils(base_noc_coverage #(DATA_WIDTH, ROUTERS_NUM))

    int router_id;
    bit is_input;
    int destination;

    covergroup base_noc_cg;
        coverpoint router_id {
            bins router_array[] = {[0:ROUTERS_NUM-1]};
        }
        
        coverpoint destination {
            bins dest_array[] = {[0:ROUTERS_NUM-1]};
        }
        
        coverpoint is_input {
            bins input_port  = {1};
            bins output_port = {0};
        }
        
        func_cov: cross router_id, destination, is_input;
    endgroup

    base_noc_config base_cfg;

    function new(string name = "base_noc_coverage", uvm_component parent = null);
        super.new(name, parent);
        if (!uvm_config_db #(base_noc_config)::get(null, "", "base_cfg", base_cfg)) 
            `uvm_fatal("CONFIG", "Config not found")
        base_noc_cg = new();
    endfunction
    
    virtual function void write(base_noc_item #(DATA_WIDTH, ROUTERS_NUM) t);
        is_input = t.is_input;
        
        for (int i = 0; i < ROUTERS_NUM; i++) begin
            if(t.local_ports[i].valid && t.local_ports[i].ready)
            begin
                router_id = i;
                destination = t.local_ports[i].destination;      
                base_noc_cg.sample();
            end
        end
    endfunction

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("COV", $sformatf("Base coverage: %.2f%%", base_noc_cg.func_cov.get_coverage()), UVM_LOW)
    endfunction
    
endclass