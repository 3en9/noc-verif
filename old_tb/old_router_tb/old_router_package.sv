`include "lib/old_router_if.sv"
package old_router_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import base_router_pkg::*;
    `include "lib/old_router_monitor.sv"
    `include "lib/old_router_driver.sv"

    `include "tests/old_router_sample_test.sv"
endpackage