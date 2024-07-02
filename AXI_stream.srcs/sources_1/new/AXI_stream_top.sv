module AXI_stream_top(
    input logic clk,
    input logic rst
    );
    
    logic [31:0] wdata;
    logic wvalid;
    logic wready;
    logic wlast;
    
    logic [31:0] rdata;
    logic rvalid;
    logic rready;
    logic rlast;
    
     AXI_stream_master master (
        .clk(clk),
        .rst(rst),
        .wdata(wdata),
        .wvalid(wvalid),
        .wready(wready),
        .wlast(wlast),
        .rdata(rdata),
        .rvalid(rvalid),
        .rready(rready),
        .rlast(rlast)
    );
    
    AXI_stream_slave slave (
        .clk(clk),
        .rst(rst),
        .wdata(wdata),
        .wvalid(wvalid),
        .wready(wready),
        .wlast(wlast),
        .rdata(rdata),
        .rvalid(rvalid),
        .rready(rready),
        .rlast(rlast)
    );
endmodule

  
    


