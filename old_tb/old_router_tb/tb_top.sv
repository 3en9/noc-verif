import uvm_pkg::*;
import base_router_pkg::*;
import old_router_pkg::*;

module tb_top;
    logic clk = 0;
    always #1 clk = ~clk;

    `ifdef MESH_TORUS
    parameter [`CS-1:0] router_X = `MASTER_ROUTER_F;
    parameter [`CS-1:0] router_Y = `MASTER_ROUTER_S;
    `elsif CIRCULANT
    parameter [`CS-1:0] router_no = `MASTER_ROUTER_F;
    `endif

    router_if dut_if(clk);

    router dut(
        .clk(clk),
        .inputs(dut_if.inputs),
        .signals_in(dut_if.signals_in),
        .outputs(dut_if.outputs),
        .signals_out(dut_if.signals_out)
        `ifdef MESH_TORUS
        , .router_X(router_X)
        , .router_Y(router_Y)
        `elsif CIRCULANT
        , .router_no(router_no)
        `endif
    );

    base_router_config base_cfg;
    initial begin
        base_cfg = new();
        base_cfg.parse_args();
        base_cfg.print();
        uvm_config_db #(base_router_config)::set(null, "*", "base_cfg", base_cfg);
        uvm_config_db #(virtual router_if)::set(null, "*", "vif", dut_if);
        run_test();
    end
endmodule