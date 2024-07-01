module AXI_stream_master (
    input  logic        clk,
    input  logic        rst,
    output logic [31:0] wdata,
    output logic        wvalid,
    input  logic        wready,
    output logic        wlast
);

    typedef enum logic [1:0] {
        IDLE,
        SEND,
        LAST
    } state_t;
    state_t state, next_state;
    logic [31:0] data_counter;

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= IDLE;
            data_counter <= 32'b0;  
        end else begin
            state <= next_state;
            if (state == SEND && wready) begin
                data_counter <= data_counter + 1;
            end
        end
    end

    always_comb begin
        next_state = state;
        wvalid = 1'b0;
        wdata = 32'b0;
        wlast = 1'b0;

        case (state)
            IDLE: begin
                if (data_counter < 32'h10) begin
                    next_state = SEND;
                end
            end

            SEND: begin
                wvalid = 1'b1;
                wdata = data_counter;
                if (wready) begin
                    if (data_counter == 32'hF) begin
                        next_state = LAST;
                    end else begin
                        next_state = SEND;
                    end
                end
            end

            LAST: begin
                wvalid = 1'b1;
                wdata = data_counter;
                wlast = 1'b1;
                if (wready) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule