module AXI_stream_slave (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] wdata,
    input  logic        wvalid,
    output logic        wready,
    input  logic        wlast,
    output logic [31:0] rdata,
    output logic        rvalid,
    input  logic        rready,
    output logic        rlast
);
    logic [31:0] memory [0:15];
    logic [3:0] write_pointer;
    logic [4:0] read_pointer;
    typedef enum logic [1:0] {
        IDLE,
        RECEIVE,
        READ,
        RLAST
    } state_t;
    state_t state, next_state;
    
    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= IDLE;
            write_pointer <= 4'b0;
            read_pointer <= 5'b0;
        end else begin
            state <= next_state;
            if (state == RECEIVE && wvalid && wready) begin
                memory[write_pointer] <= wdata;
                write_pointer <= write_pointer + 1;
            end
             if (state == READ && rready && rvalid) begin
                read_pointer <= read_pointer + 1;
            end
        end
    end
    
    always_comb begin
        next_state = state;
        wready = (state == RECEIVE);
        rvalid = 1'b0;
        rlast = 1'b0;
        rdata = 32'b0;
        
        case (state)
            IDLE: begin
                if (wvalid) begin
                    next_state = RECEIVE;
                end else if (rready && read_pointer < 5'h10 ) begin
                    next_state = READ;
                end
            end
            RECEIVE: begin
                if (wlast && wvalid) begin
                    next_state = IDLE;
                end     
            end
            
             READ: begin
                rvalid = 1'b1;
                rdata = memory[read_pointer];
                //rlast = (read_pointer == 5'h10);
//                if (read_pointer == 4'hF) begin
//                    rlast = 1'b1;
//                end
                if (rready) begin
//                    if (rlast) begin
//                        next_state = IDLE;
//                        read_pointer = 5'b0; 
//                    end
                      if(read_pointer == 4'hF) begin
                        next_state = RLAST;
                      end else begin
                        next_state = READ;
                      end
                end
            end
            RLAST: begin
                rvalid <= 1'b0;
                rlast <= 1'b1;
                rdata = memory[read_pointer];
                if (rready) begin
                    next_state = IDLE;
                end
            end
        endcase
    end
endmodule