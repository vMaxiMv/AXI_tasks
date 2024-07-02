module tb_AXI_stream_top;

    logic clk;
    logic rst;

    AXI_stream_top top (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

     task monitor_signals;
        $display("Time=%0t: wdata=%h, wvalid=%b, wready=%b, wlast=%b, rdata=%h, rvalid=%b, rready=%b, rlast=%b, top.slave.write_pointer=%b, top.slave.read_pointer=%b", 
                 $time, top.wdata, top.wvalid, top.wready, top.wlast, top.rdata, top.rvalid, top.rready, top.rlast, top.slave.write_pointer, top.slave.read_pointer);
    endtask
    
     initial begin
        clk = 0;
        rst = 0;
        
        #10 rst = 1;
        
        wait(top.wvalid);
        $display("Write transmission started");

        repeat(16) begin
            @(posedge clk);
            monitor_signals();
        end
        
         wait(top.wlast);
        @(posedge clk);
        monitor_signals();
        $display("Write transmission completed");
        
        wait(top.rvalid);
        $display("Read transmission started");
        repeat(16) begin
            @(posedge clk);
            monitor_signals();
        end
        
        wait(top.rlast);
        @(posedge clk);
        monitor_signals();
        $display("Read transmission completed");

        for (int i = 0; i < 16; i++) begin
            $display("Memory[%0d] = %h", i, top.slave.memory[i]);
        end

        #100;
        $finish;
    end
    
    always @(posedge clk) begin
        if (top.wvalid && top.wready) begin
            if (top.wdata == top.slave.write_pointer) begin
                $display("Write successful: data=%h, write_pointer=%h", top.wdata, top.slave.write_pointer);
            end else begin
                $error("Data mismatch: expected %h, got %h", top.slave.write_pointer, top.wdata);
            end
        end
        
         if (top.rvalid && top.rready) begin
            if (top.rdata == top.slave.read_pointer) begin
                $display("Read successful: data=%h, read_pointer=%h", top.rdata, top.slave.read_pointer);
            end else begin
                $error("Read data mismatch: expected %h, got %h", top.slave.read_pointer, top.rdata);
            end
        end
    end

endmodule

