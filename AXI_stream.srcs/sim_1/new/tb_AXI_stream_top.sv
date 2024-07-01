module tb_AXI_stream_top;

    logic clk;
    logic rst;

    AXI_stream_top top (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

     task monitor_signals;
        $display("Time=%0t: wdata=%h, wvalid=%b, wready=%b, wlast=%b, top.slave.write_pointer=%b, top.master.data_counter=%b", 
                 $time, top.wdata, top.wvalid, top.wready, top.wlast, top.slave.write_pointer,top.master.data_counter,);
    endtask
    
     initial begin
        clk = 0;
        rst = 0;
        
        #10 rst = 1;
        
        wait(top.wvalid);
        $display("Transmission started");

        repeat(16) begin
            @(posedge clk);
            monitor_signals();
        end
        
         wait(top.wlast);
        @(posedge clk);
        monitor_signals();
        $display("Transmission completed");

        for (int i = 0; i < 16; i++) begin
            $display("Memory[%0d] = %h", i, top.slave.memory[i]);
        end

        #100;
        $finish;
    end
    
    always @(posedge clk) begin
        if (top.wvalid && top.wready) begin
            assert(top.wdata == top.slave.write_pointer)
            else $error("Data unsuccess: expected %h, got %h", top.slave.write_pointer, top.wdata);
        end
    end

endmodule

