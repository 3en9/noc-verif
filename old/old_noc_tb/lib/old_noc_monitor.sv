class old_noc_monitor extends base_noc_monitor #(`PL-2*`CS-1, `RN);
    `uvm_component_utils(old_noc_monitor)

    virtual noc_if vif;

    function new(string name = "old_noc_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual noc_if)::get(this, "", "vif", vif)) 
            `uvm_fatal("MON", "Virtual interface not found")
    endfunction

    function int get_y(int id);
        return id / `X;
    endfunction
    
    function int get_x(int id);
        return id % `X;
    endfunction

    function int extract_dest(logic [`PL-1:0] data);
        int x, y;
        x = data[`CS -: `CS];
        y = data[2*`CS -: `CS];
        return y * `X + x;
    endfunction

    function int extract_data(logic [`PL-1:0] data);
        return data[`PL-1 -: (`PL - 2*`CS)];
    endfunction
    
    task run_phase(uvm_phase phase);
        base_noc_item #(`PL-2*`CS-1, `RN) in_item;
        base_noc_item #(`PL-2*`CS-1, `RN) out_item;
        
        forever begin
            @(posedge vif.clk);
            
            in_item = base_noc_item #(`PL-2*`CS-1, `RN)::type_id::create("in_item");
            in_item.is_input = 1;
            
            for (int i = 0; i < `RN; i++) begin
                `ifdef MESH_TORUS
                int y = get_y(i);
                int x = get_x(i);
                in_item.local_ports[i].valid       = vif.core_outputs[y][x][0];
                in_item.local_ports[i].destination = extract_dest(vif.core_outputs[y][x]);
                in_item.local_ports[i].data        = extract_data(vif.core_outputs[y][x]);
                in_item.local_ports[i].ready       = vif.core_availability_signals_in[y][x];
                `elsif CIRCULANT
                in_item.local_ports[i].valid       = vif.core_outputs[i][0];
                in_item.local_ports[i].destination = vif.core_outputs[i][`CS -: `CS];
                in_item.local_ports[i].data        = vif.core_outputs[i][`PL-1 -: (`PL - `CS)];
                in_item.local_ports[i].ready       = vif.core_availability_signals_in[i];
                `endif
            end
            
            mon_analysis_port.write(in_item);
            
            out_item = base_noc_item #(`PL-2*`CS-1, `RN)::type_id::create("out_item");
            out_item.is_input = 0;
            
            for (int i = 0; i < `RN; i++) begin
                `ifdef MESH_TORUS
                int y = get_y(i);
                int x = get_x(i);
                out_item.local_ports[i].valid       = vif.core_inputs[y][x][0];
                out_item.local_ports[i].destination = extract_dest(vif.core_inputs[y][x]);
                out_item.local_ports[i].data        = extract_data(vif.core_inputs[y][x]);
                out_item.local_ports[i].ready       = vif.core_availability_signals_out[y][x];
                `elsif CIRCULANT
                out_item.local_ports[i].valid       = vif.core_inputs[i][0];
                out_item.local_ports[i].destination = vif.core_inputs[i][`CS -: `CS];
                out_item.local_ports[i].data        = vif.core_inputs[i][`PL-1 -: (`PL - `CS)];
                out_item.local_ports[i].ready       = vif.core_availability_signals_out[i];
                `endif
            end
            
            mon_analysis_port.write(out_item);
        end
    endtask
    
endclass