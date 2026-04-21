package base_router_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    `include "lib/base_router_config.sv"
    `include "lib/base_router_item.sv"
    `include "lib/base_router_driver.sv"
    `include "lib/base_router_monitor.sv"
    `include "lib/base_router_sequencer.sv"
    `include "lib/base_router_agent.sv"
    `include "lib/base_router_scoreboard.sv"
    `include "lib/base_router_coverage.sv"
    `include "lib/base_router_env.sv"

    `include "tests/base_router_rand_test.sv"
endpackage