class base_noc_item #(parameter DATA_WIDTH = 32, ROUTERS_NUM=16) extends uvm_sequence_item;
    `uvm_object_param_utils(base_noc_item#(DATA_WIDTH, ROUTERS_NUM))

    base_router_port #(DATA_WIDTH) local_ports[ROUTERS_NUM];

    bit is_input;

    function new(string name="base_noc_item");
        super.new(name);
        for (int i=0; i<ROUTERS_NUM; ++i) begin
            local_ports[i] = new();
        end
    endfunction

    function void init();
        foreach(local_ports[i]) local_ports[i].valid = 0;
    endfunction

    function void set_router(int router_num, logic [DATA_WIDTH-1:0] data, int destination);
        if(router_num >= ROUTERS_NUM) `uvm_fatal("ITEM.set_router", $sformatf("router_num(%0d) >= ROUTERS_NUM(%0d)", router_num, ROUTERS_NUM))
        local_ports[router_num].data = data;
        local_ports[router_num].valid = 1;
        local_ports[router_num].destination = destination;
    endfunction

    function string convert2str();
        string str = "\n";
        foreach(local_ports[i]) begin
            str = {str, $sformatf("%h, %b, %0d", local_ports[i].data, local_ports[i].valid, local_ports[i].destination)};
            str = {str, "\n"};
        end
        return str;
    endfunction
endclass