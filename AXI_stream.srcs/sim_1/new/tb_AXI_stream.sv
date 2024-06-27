module tb_AXI_stream;
    logic clk;
    logic rst;
    logic [31:0] wdata;
    logic wvalid;
    logic wready;
    logic wlast;

AXI_stream_master master (
    .clk(clk),
    .rst(rst),
    .wdata(wdata),
    .wvalid(wvalid),
    .wready(wready),
    .wlast(wlast)
);

AXI_stream_slave slave (
     .clk(clk),
     .rst(rst),
     .wdata(wdata),
     .wvalid(wvalid),
     .wready(wready),
     .wlast(wlast)
);

always #5 clk = ~clk;
initial begin

        clk = 0;
        rst = 0;
        #10 rst = 1;

        #1000;
        $stop;
    end

endmodule
