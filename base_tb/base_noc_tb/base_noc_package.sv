package base_noc_pkg;
    import uvm_pkg::*;
    import base_router_pkg::*;
    `include "uvm_macros.svh"
    `include "lib/base_noc_config.sv"
    `include "lib/base_noc_item.sv"
    `include "lib/base_noc_driver.sv"
    `include "lib/base_noc_monitor.sv"
    `include "lib/base_noc_sequencer.sv"
    `include "lib/base_noc_agent.sv"
    `include "lib/base_noc_scoreboard.sv"
    `include "lib/base_noc_coverage.sv"
    `include "lib/base_noc_env.sv"

    `include "tests/base_noc_sample_test.sv"
endpackage