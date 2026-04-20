class old_noc_driver extends base_noc_driver #(`PL-2*`CS-1, `RN);
    `uvm_component_utils(old_noc_driver)

    virtual noc_if vif;
    base_router_port #(`PL-2*`CS-1) pending_packets[`RN][$];

    function new(string name = "old_noc_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual noc_if)::get(this, "", "vif", vif)) 
            `uvm_fatal("DRV", "Virtual interface not found")
    endfunction

    function logic [`CS-1:0] get_dest_x(int destination);
        return destination % `X;
    endfunction

    function logic [`CS-1:0] get_dest_y(int destination);
        return destination / `X;
    endfunction

    function int get_y(int i);
        return i / `X;
    endfunction
    
    function int get_x(int i);
        return i % `X;
    endfunction
    
    task run_phase(uvm_phase phase);
        base_noc_item #(`PL-2*`CS-1, `RN) item;
        
        forever begin
            seq_item_port.get_next_item(item);
            
            for (int i = 0; i < `RN; i++) begin
                if (item.local_ports[i].valid) begin
                    pending_packets[i].push_back(item.local_ports[i]);
                end
            end
            
            set_availability_signals();
            send_packet();
            seq_item_port.item_done();
        end
    endtask
    
    task set_availability_signals();
    `ifdef MESH_TORUS
    for (int i = 0; i < `RN; i++) begin
        int y = get_y(i);
        int x = get_x(i);
        vif.core_availability_signals_out[y][x] <= base_cfg.RAND_READY >= $urandom_range(0, 100) ? 1 : 0;
    end
    `elsif CIRCULANT
    for (int i = 0; i < `RN; i++) begin
        vif.core_availability_signals_out[i] <=  base_cfg.RAND_READY >= $urandom_range(0, 100) ? 1 : 0;
    end
    `endif
    endtask

    task send_packet();
    `ifdef MESH_TORUS
        for (int i = 0; i < `RN; i++) begin
            int y = get_y(i);
            int x = get_x(i);
            
            if (vif.core_availability_signals_in[y][x] && pending_packets[i].size() > 0) begin
                base_router_port #(`PL-2*`CS-1) pkt;
                pkt = pending_packets[i].pop_front();
                
                vif.core_outputs[y][x][0] <= pkt.valid;
                vif.core_outputs[y][x][`CS -: `CS] <= get_dest_x(pkt.destination);
                vif.core_outputs[y][x][2*`CS -: `CS] <= get_dest_y(pkt.destination);
                vif.core_outputs[y][x][`PL-1 -: (`PL - 2*`CS)] <= pkt.data;
            end
            else begin
                vif.core_outputs[y][x][0] <= 0;
            end
        end
    `elsif CIRCULANT
        for (int i = 0; i < `RN; i++) begin
            if (vif.core_availability_signals_in[i] && pending_packets[i].size() > 0) begin
                base_router_port #(`PL-2*`CS-1) pkt;
                pkt = pending_packets[i].pop_front();
                
                vif.core_outputs[i][0] <= pkt.valid;
                vif.core_outputs[i][`CS -: `CS] <= pkt.destination;
                vif.core_outputs[i][`PL-1 -: (`PL - `CS)] <= pkt.data;
            end
            else begin
                vif.core_outputs[i][0] <= 0;
            end
        end
    `endif
        @(posedge vif.clk);
    endtask
    
endclass