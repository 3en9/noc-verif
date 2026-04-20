class old_router_monitor extends base_router_monitor #(`PL-2*`CS-1, `REN);
    `uvm_component_utils(old_router_monitor)

    virtual router_if vif;

    function new(string name = "old_router_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual router_if)::get(this, "", "vif", vif)) `uvm_fatal("MON", "Virtual interface not found")
    endfunction

    function int extract_dest(logic [`PL-1:0] data);
        int x, y;
        x = data[1+:`CS];
        y = data[`CS+1+:`CS];
        return y * `X + x;
    endfunction

    function int extract_data(logic [`PL-1:0] data);
        return data[`PL-1 -: (`PL - 2*`CS)];
    endfunction
    
    task run_phase(uvm_phase phase);
        base_router_item #(`PL-2*`CS-1, `REN) in_item;
        base_router_item #(`PL-2*`CS-1, `REN) out_item;
        
        forever begin
            @(posedge vif.clk);
            
            in_item = base_router_item #(`PL-2*`CS-1, `REN)::type_id::create("in_item");
            in_item.is_input = 1;
            
            foreach (vif.inputs[i]) begin
                in_item.ports[i].valid       = vif.inputs[i][0];
                `ifdef MESH_TORUS
                in_item.ports[i].destination = extract_dest(vif.inputs[i]);
                in_item.ports[i].data        = extract_data(vif.inputs[i]);
                `elsif CIRCULANT
                in_item.ports[i].destination = vif.inputs[i][1+:`CS];
                in_item.ports[i].data = vif.inputs[i][`PL-1 -: (`PL - `CS)];
                `endif
                in_item.ports[i].ready       = vif.signals_out[i];
            end
            
            mon_analysis_port.write(in_item);
            
            out_item = base_router_item #(`PL-2*`CS-1, `REN)::type_id::create("out_item");
            out_item.is_input = 0;
            
            foreach (vif.outputs[i]) begin
                out_item.ports[i].valid       = vif.outputs[i][0];
                out_item.ports[i].destination = extract_dest(vif.outputs[i]);
                out_item.ports[i].data        = extract_data(vif.outputs[i]);
                out_item.ports[i].ready       = vif.signals_in[i];
            end
            
            mon_analysis_port.write(out_item);
        end
    endtask
endclass