class base_noc_scoreboard #(parameter DATA_WIDTH = 32, ROUTERS_NUM = 16) extends uvm_scoreboard;
    
    `uvm_component_param_utils(base_noc_scoreboard #(DATA_WIDTH, ROUTERS_NUM))

    uvm_analysis_imp #(base_noc_item #(DATA_WIDTH, ROUTERS_NUM), 
                       base_noc_scoreboard #(DATA_WIDTH, ROUTERS_NUM)) analysis_export;
    
    int total_input_accepted;
    int total_input_dropped;
    int total_output_ejected;
    int total_output_stalled;
    
    int input_accepted_by_router[ROUTERS_NUM];
    int input_dropped_by_router[ROUTERS_NUM];
    int output_ejected_by_router[ROUTERS_NUM];
    int output_stalled_by_router[ROUTERS_NUM];
    
    function new(string name = "base_noc_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        analysis_export = new("analysis_export", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        clear_all();
    endfunction
    
    function void clear_all();
        total_input_accepted = 0;
        total_input_dropped = 0;
        total_output_ejected = 0;
        total_output_stalled = 0;
        
        for (int i = 0; i < ROUTERS_NUM; i++) begin
            input_accepted_by_router[i] = 0;
            input_dropped_by_router[i] = 0;
            output_ejected_by_router[i] = 0;
            output_stalled_by_router[i] = 0;
        end
    endfunction

    function void write(base_noc_item #(DATA_WIDTH, ROUTERS_NUM) t);
        for (int i = 0; i < ROUTERS_NUM; i++) begin
            if (t.local_ports[i].valid) begin
                if (t.is_input) begin
                    if (t.local_ports[i].ready) begin
                        total_input_accepted++;
                        input_accepted_by_router[i]++;
                        `uvm_info("BASE_SCBD", 
                                  $sformatf("[INPUT]  Router %0d: ACCEPTED (dest=%0d)", 
                                            i, t.local_ports[i].destination), 
                                  UVM_MEDIUM)
                    end else begin
                        total_input_dropped++;
                        input_dropped_by_router[i]++;
                        `uvm_warning("BASE_SCBD", 
                                     $sformatf("[INPUT]  Router %0d: DROPPED", i))
                    end
                end
                else begin
                    if (t.local_ports[i].ready) begin
                        total_output_ejected++;
                        output_ejected_by_router[i]++;
                        `uvm_info("BASE_SCBD", 
                                  $sformatf("[OUTPUT] Router %0d: EJECTED (data=0x%0h)", 
                                            i, t.local_ports[i].data), 
                                  UVM_MEDIUM)
                    end else begin
                        total_output_stalled++;
                        output_stalled_by_router[i]++;
                        `uvm_warning("BASE_SCBD", 
                                     $sformatf("[OUTPUT] Router %0d: STALLED", i))
                    end
                end
            end
        end
    endfunction
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        
        `uvm_info("BASE_SCBD", 
                  $sformatf("\n========================================\nSCOREBOARD REPORT\n========================================\nINPUT:\n  Accepted: %0d\n  Dropped:  %0d\n\nOUTPUT:\n  Ejected:  %0d\n  Stalled:  %0d\n========================================",
                            total_input_accepted, total_input_dropped,
                            total_output_ejected, total_output_stalled), 
                  UVM_LOW)
        
        if (total_input_accepted > 0 || total_output_ejected > 0) begin
            `uvm_info("BASE_SCBD", "\nPer-router statistics:", UVM_LOW)
            for (int i = 0; i < ROUTERS_NUM; i++) begin
                if (input_accepted_by_router[i] > 0 || input_dropped_by_router[i] > 0 ||
                    output_ejected_by_router[i] > 0 || output_stalled_by_router[i] > 0) begin
                    `uvm_info("BASE_SCBD", 
                              $sformatf("  Router %0d: in(acc=%0d drop=%0d) out(ejc=%0d stall=%0d)",
                                        i, 
                                        input_accepted_by_router[i], input_dropped_by_router[i],
                                        output_ejected_by_router[i], output_stalled_by_router[i]), 
                              UVM_LOW)
                end
            end
        end
    endfunction 
    
endclass