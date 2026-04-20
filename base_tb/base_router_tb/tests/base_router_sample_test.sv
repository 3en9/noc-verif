class base_router_sample_sequence #(parameter DATA_WIDTH = 32, NUM_PORTS=4) extends uvm_sequence;
  `uvm_object_utils (base_router_sample_sequence#(DATA_WIDTH, NUM_PORTS))
  
  base_router_config base_cfg;

  function new (string name = "base_router_sample_sequence");
    super.new (name);
    if(!uvm_config_db#(base_router_config)::get(null, "", "base_cfg", base_cfg)) `uvm_fatal("CONFIG", "Component was not properly configured");;
  endfunction

  task body();
    base_router_item #(DATA_WIDTH, NUM_PORTS) m_item = base_router_item#(DATA_WIDTH, NUM_PORTS)::type_id::create("m_item");
    int dest_router;
    if(base_cfg.SRC_PORT >= NUM_PORTS) `uvm_fatal("SEQ", "SRC_PORT >= NUM_PORTS")
    if(base_cfg.DEST_ROUTER >= base_cfg.ROUTERS_NUM) `uvm_fatal("SEQ", "DEST_ROUTER >= ROUTERS_NUM")
    repeat(base_cfg.PACKETS_COUNT) begin
      logic [DATA_WIDTH-1:0] data = $urandom_range(0, 2**DATA_WIDTH-1);
      
      start_item(m_item);
      m_item.init();
      dest_router = (base_cfg.DEST_ROUTER == -1) ? $urandom_range(0, base_cfg.ROUTERS_NUM - 1) : base_cfg.DEST_ROUTER;
      if(base_cfg.SRC_PORT == -1) begin
        for(int pn=0; pn < NUM_PORTS; pn++) begin
          if($urandom_range(0, 1) || base_cfg.STRESS_MODE) m_item.set_port(pn, data, dest_router);
        end
      end
      else begin
        m_item.set_port(base_cfg.SRC_PORT, data, dest_router);
      end
      `uvm_info("SEQ", m_item.convert2str(), UVM_HIGH)
      finish_item(m_item);
    end
  endtask
endclass

class base_router_sample_test #(parameter DATA_WIDTH = 32, NUM_PORTS=4) extends uvm_test;
  `uvm_component_utils(base_router_sample_test#(DATA_WIDTH, NUM_PORTS))
  base_router_env #(DATA_WIDTH, NUM_PORTS) env;
  function new(string name = "base_router_sample_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = base_router_env#(DATA_WIDTH, NUM_PORTS)::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    base_router_sample_sequence#(DATA_WIDTH, NUM_PORTS) seq = base_router_sample_sequence#(DATA_WIDTH, NUM_PORTS)::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask
endclass