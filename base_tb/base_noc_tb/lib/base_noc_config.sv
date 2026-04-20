class base_noc_config extends uvm_object;
  `uvm_object_utils(base_noc_config)

  int PACKETS_COUNT;
  int RAND_READY;
  int SRC_ROUTER;
  int DEST_ROUTER;
  bit STRESS_MODE;

  function new(string name = "cfg");
    super.new(name);
    PACKETS_COUNT = 100;
    RAND_READY = 100;
    SRC_ROUTER = -1;
    DEST_ROUTER = -1;
    STRESS_MODE = 0;
  endfunction

  function void parse_args();
    if($value$plusargs("PACKETS_COUNT=%d", PACKETS_COUNT));
    if($value$plusargs("RAND_READY=%d", RAND_READY));
    if($value$plusargs("SRC_ROUTER=%d", SRC_ROUTER));
    if($value$plusargs("DEST_ROUTER=%d", DEST_ROUTER));
    if($value$plusargs("STRESS_MODE=%b", STRESS_MODE));
  endfunction

  function void print();
    uvm_report_info(get_type_name(), $sformatf("PACKETS_COUNT = %d", PACKETS_COUNT), UVM_NONE);
    uvm_report_info(get_type_name(), $sformatf("RAND_READY = %d", RAND_READY), UVM_NONE);
    uvm_report_info(get_type_name(), $sformatf("SRC_ROUTER = %d", SRC_ROUTER), UVM_NONE);
    uvm_report_info(get_type_name(), $sformatf("DEST_ROUTER = %d", DEST_ROUTER), UVM_NONE);
    uvm_report_info(get_type_name(), $sformatf("STRESS_MODE = %d", STRESS_MODE), UVM_NONE);
  endfunction
endclass