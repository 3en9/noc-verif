`include "lib/old_noc_if.sv"
package old_noc_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import base_router_pkg::*;
    import base_noc_pkg::*;
    `include "lib/old_noc_monitor.sv"
    `include "lib/old_noc_driver.sv"

    `include "tests/old_noc_rand_test.sv"
endpackage