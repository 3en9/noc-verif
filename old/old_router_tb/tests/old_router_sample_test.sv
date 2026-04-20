class old_router_sample_test extends base_router_sample_test#(`PL-2*`CS-1, `REN);
    `uvm_component_utils(old_router_sample_test)
    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        base_router_driver#(`PL-2*`CS-1, `REN)::type_id::set_type_override(old_router_driver::get_type());
        base_router_monitor#(`PL-2*`CS-1, `REN)::type_id::set_type_override(old_router_monitor::get_type());
    endfunction
endclass