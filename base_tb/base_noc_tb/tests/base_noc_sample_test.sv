class base_noc_sample_sequence #(parameter DATA_WIDTH = 32, ROUTERS_NUM=16) extends uvm_sequence;
  `uvm_object_utils (base_noc_sample_sequence#(DATA_WIDTH, ROUTERS_NUM))
  
  base_noc_config base_cfg;

  function new (string name = "base_noc_sample_sequence");
    super.new (name);
    if(!uvm_config_db#(base_noc_config)::get(null, "", "base_cfg", base_cfg)) `uvm_fatal("CONFIG", "Component was not properly configured");;
  endfunction

  task body();
    base_noc_item #(DATA_WIDTH, ROUTERS_NUM) m_item = base_noc_item#(DATA_WIDTH, ROUTERS_NUM)::type_id::create("m_item");
    int dest_router;
    if(base_cfg.SRC_ROUTER >= ROUTERS_NUM) `uvm_fatal("SEQ", "SRC_ROUTER >= ROUTERS_NUM")
    if(base_cfg.DEST_ROUTER >= ROUTERS_NUM) `uvm_fatal("SEQ", "DEST_ROUTER >= ROUTERS_NUM")
    repeat(base_cfg.PACKETS_COUNT) begin
      logic [DATA_WIDTH-1:0] data = $urandom_range(0, 2**DATA_WIDTH-1);
      
      start_item(m_item);
      m_item.init();
      dest_router = (base_cfg.DEST_ROUTER == -1) ? $urandom_range(0, ROUTERS_NUM - 1) : base_cfg.DEST_ROUTER;
      if(base_cfg.SRC_ROUTER == -1) begin
        for(int pn=0; pn < ROUTERS_NUM; pn++) begin
          if($urandom_range(0, 1) || base_cfg.STRESS_MODE) m_item.set_router(pn, data, $urandom_range(0, ROUTERS_NUM - 1));
        end
      end
      else begin
        m_item.set_router(base_cfg.SRC_ROUTER, data, dest_router);
      end
      `uvm_info("SEQ", m_item.convert2str(), UVM_HIGH)
      finish_item(m_item);
    end
  endtask
endclass

class base_noc_sample_test #(parameter DATA_WIDTH = 32, ROUTERS_NUM=16) extends uvm_test;
  `uvm_component_utils(base_noc_sample_test#(DATA_WIDTH, ROUTERS_NUM))
  base_noc_env #(DATA_WIDTH, ROUTERS_NUM) env;
  function new(string name = "base_noc_sample_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = base_noc_env#(DATA_WIDTH, ROUTERS_NUM)::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    base_noc_sample_sequence#(DATA_WIDTH, ROUTERS_NUM) seq = base_noc_sample_sequence#(DATA_WIDTH, ROUTERS_NUM)::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(env.agent.sequencer);
    phase.drop_objection(this);
  endtask
endclass