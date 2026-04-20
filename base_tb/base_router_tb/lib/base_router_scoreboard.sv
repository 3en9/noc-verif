class base_router_scoreboard #(parameter int DATA_WIDTH = 32,parameter int NUM_PORTS  = 4) extends uvm_scoreboard;
    
    `uvm_component_param_utils(base_router_scoreboard #(DATA_WIDTH, NUM_PORTS))

    uvm_analysis_imp #(base_router_item #(DATA_WIDTH, NUM_PORTS), base_router_scoreboard #(DATA_WIDTH, NUM_PORTS)) analysis_export;
    
    int total_input_accepted;
    int total_input_dropped;
    int total_output_ejected;
    int total_output_stalled;
    
    function new(string name = "base_router_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        analysis_export = new("analysis_export", this);
    endfunction

    function void write(base_router_item #(DATA_WIDTH, NUM_PORTS) t);
        for (int i = 0; i < NUM_PORTS; i++) begin
            if (t.ports[i].valid) begin
                if (t.is_input) begin
                    if (t.ports[i].ready) begin
                        total_input_accepted++;
                        `uvm_info("BASE_SCBD", $sformatf("[INPUT]  Port %0d: ACCEPTED", i), UVM_MEDIUM)
                    end else begin
                        total_input_dropped++;
                        `uvm_warning("BASE_SCBD", $sformatf("[INPUT]  Port %0d: DROPPED", i))
                    end
                end
                else begin
                    if (t.ports[i].ready) begin
                        total_output_ejected++;
                        `uvm_info("BASE_SCBD", $sformatf("[OUTPUT] Port %0d: EJECTED", i), UVM_MEDIUM)
                    end else begin
                        total_output_stalled++;
                        `uvm_warning("BASE_SCBD", $sformatf("[OUTPUT] Port %0d: STALLED", i))
                    end
                end
            end
        end
    endfunction
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("BASE_SCBD", 
                  $sformatf("INPUT: accepted=%0d dropped=%0d | OUTPUT: ejected=%0d stalled=%0d",
                            total_input_accepted, total_input_dropped,
                            total_output_ejected, total_output_stalled), UVM_LOW)
    endfunction 
endclass