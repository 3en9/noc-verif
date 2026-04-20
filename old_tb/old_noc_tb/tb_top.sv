import uvm_pkg::*;
import base_noc_pkg::*;
import old_noc_pkg::*;

module tb_top;
    logic clk = 0;
    always #1 clk = ~clk;

    noc_if dut_if(clk);

    noc dut(
        .clk(clk),
        .core_inputs(dut_if.core_inputs),
        .core_outputs(dut_if.core_outputs),
        .core_availability_signals_in(dut_if.core_availability_signals_in),
        .core_availability_signals_out(dut_if.core_availability_signals_out)
    );

    base_noc_config base_cfg;
    initial begin
        base_cfg = new();
        base_cfg.parse_args();
        base_cfg.print();
        uvm_config_db #(base_noc_config)::set(null, "*", "base_cfg", base_cfg);
        uvm_config_db #(virtual noc_if)::set(null, "*", "vif", dut_if);
        run_test();
    end
endmodule