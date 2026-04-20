class base_router_config extends uvm_object;
  `uvm_object_utils(base_router_config)

  int ROUTERS_NUM;
  int PACKETS_COUNT;
  int SRC_PORT;
  int DEST_ROUTER;
  int RAND_READY;
  bit STRESS_MODE;

  function new(string name = "cfg");
    super.new(name);
    ROUTERS_NUM = 0;
    PACKETS_COUNT = 100;
    SRC_PORT = -1;
    DEST_ROUTER = -1;
    RAND_READY = 100;
    STRESS_MODE = 0;
  endfunction

  function void parse_args();
    if($value$plusargs("ROUTERS_NUM=%d", ROUTERS_NUM));
    if($value$plusargs("PACKETS_COUNT=%d", PACKETS_COUNT));
    if($value$plusargs("SRC_PORT=%d", SRC_PORT));
    if($value$plusargs("DEST_ROUTER=%d", DEST_ROUTER));
    if($value$plusargs("RAND_READY=%d", RAND_READY));
    if($value$plusargs("STRESS_MODE=%b", STRESS_MODE));
  endfunction

  function void print();
    uvm_report_info(get_type_name(), $sformatf("ROUTERS_NUM = %d", ROUTERS_NUM), UVM_NONE);
    uvm_report_info(get_type_name(), $sformatf("PACKETS_COUNT = %d", PACKETS_COUNT), UVM_NONE);
    uvm_report_info(get_type_name(), $sformatf("SRC_PORT = %d", SRC_PORT), UVM_NONE);
    uvm_report_info(get_type_name(), $sformatf("DEST_ROUTER = %d", DEST_ROUTER), UVM_NONE);
    uvm_report_info(get_type_name(), $sformatf("RAND_READY = %d", RAND_READY), UVM_NONE);
    uvm_report_info(get_type_name(), $sformatf("STRESS_MODE = %b", STRESS_MODE), UVM_NONE);
  endfunction
endclass