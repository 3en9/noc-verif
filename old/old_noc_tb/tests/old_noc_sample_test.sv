class old_noc_sample_test extends base_noc_sample_test#(`PL-2*`CS-1, `RN);
    `uvm_component_utils(old_noc_sample_test)
    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        base_noc_driver#(`PL-2*`CS-1, `RN)::type_id::set_type_override(old_noc_driver::get_type());
        base_noc_monitor#(`PL-2*`CS-1, `RN)::type_id::set_type_override(old_noc_monitor::get_type());
    endfunction
endclass