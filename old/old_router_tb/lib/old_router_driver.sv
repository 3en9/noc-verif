class old_router_driver extends base_router_driver #(`PL-2*`CS-1, `REN);
    `uvm_component_utils(old_router_driver)

    virtual router_if vif;
    base_router_port #(`PL-2*`CS-1) pending_packets[`REN][$];

    function new(string name = "old_router_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual router_if)::get(this, "", "vif", vif)) `uvm_fatal("DRV", "Virtual interface not found")
    endfunction

    function logic [`CS-1:0] get_dest_x(int destination);
        return destination % `X;
    endfunction

    function logic [`CS-1:0] get_dest_y(int destination);
        return destination / `X;
    endfunction
    
    task run_phase(uvm_phase phase);
        base_router_item #(`PL-2*`CS-1, `REN) item;
        
        forever begin
            seq_item_port.get_next_item(item);
            
            foreach (item.ports[i]) begin
                if(item.ports[i].valid) begin
                    pending_packets[i].push_back(item.ports[i]);
                end
                vif.signals_in[i]      <=  base_cfg.RAND_READY >= $urandom_range(0, 100) ? 1 : 0;
            end
            send_packet();
            seq_item_port.item_done();
        end
    endtask

    task send_packet();
        foreach(pending_packets[i]) begin
            if(vif.signals_out[i] && pending_packets[i].size() > 0) begin
                base_router_port #(`PL-2*`CS-1) pkt;
                pkt = pending_packets[i].pop_front();
                vif.inputs[i][0]       <= pkt.valid;
                `ifdef MESH_TORUS
                vif.inputs[i][`CS -: `CS]    <= get_dest_x(pkt.destination);
                vif.inputs[i][2*`CS -: `CS]  <= get_dest_y(pkt.destination);
                vif.inputs[i][`PL-1 -: (`PL - 2*`CS)] <= pkt.data;
                `elsif CIRCULANT
                vif.inputs[i][`CS -: `CS] <= pkt.destination;
                vif.inputs[i][`PL-1 -: (`PL - `CS)] <= pkt.data;
                `endif
            end
            else begin
                vif.inputs[i][0] <= 0;
            end
        end
        @(posedge vif.clk);
    endtask
endclass