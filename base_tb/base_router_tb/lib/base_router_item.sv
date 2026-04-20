class base_router_port #(parameter DATA_WIDTH=32);
    logic [DATA_WIDTH-1:0] data;
    bit valid;
    bit ready;
    int destination;
endclass

class base_router_item #(parameter DATA_WIDTH = 32, NUM_PORTS=4) extends uvm_sequence_item;
    `uvm_object_param_utils(base_router_item#(DATA_WIDTH, NUM_PORTS))

    base_router_port #(DATA_WIDTH) ports[NUM_PORTS];

    bit is_input;

    function new(string name="base_router_item");
        super.new(name);
        for (int i=0; i<NUM_PORTS; ++i) begin
            ports[i] = new();
        end
    endfunction

    function void init();
        foreach(ports[i]) ports[i].valid = 0;
    endfunction

    function void set_port(int port_num, logic [DATA_WIDTH-1:0] data, int destination);
        if(port_num >= NUM_PORTS) `uvm_fatal("ITEM.set_port", $sformatf("port_num(%0d) >= NUM_PORTS(%0d)", port_num, NUM_PORTS))
        ports[port_num].data = data;
        ports[port_num].valid = 1;
        ports[port_num].destination = destination;
    endfunction

    function string convert2str();
        string str = "\n";
        foreach(ports[i]) begin
            str = {str, $sformatf("%h, %b, %0d", ports[i].data, ports[i].valid, ports[i].destination)};
            str = {str, "\n"};
        end
        return str;
    endfunction
endclass