module AXI_stream_slave (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] wdata,
    input  logic        wvalid,
    output logic        wready,
    input  logic        wlast
);

    logic [31:0] memory [0:15];
    logic [3:0] write_pointer;
    logic ready;

    typedef enum logic [1:0] {
        IDLE,
        RECEIVE
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= IDLE;
            write_pointer <= 4'b0;
            ready <= 1'b0;
        end else begin
            state <= next_state;
            if (state == RECEIVE && wvalid) begin
                memory[write_pointer] <= wdata;
                if (wlast) begin
                    write_pointer <= 4'b0;
                    ready <= 1'b0;
                end else begin
                    write_pointer <= write_pointer + 1;
                end
            end
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                ready = 1'b0;
                if (wvalid) begin
                    next_state = RECEIVE;
                end
            end

            RECEIVE: begin
                ready = 1'b1;
                if (wlast && wvalid) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    assign wready = ready;

endmodule

