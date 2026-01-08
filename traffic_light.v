module traffic_light (
    input  wire clk, rst,
    input  wire ns, ew,

    output reg [2:0] NS_str, NS_right,
    output reg [2:0] EW_str, EW_right
);

    // Light encoding
    localparam R = 3'b100;  // Bcd - 4
    localparam Y = 3'b010;  // Bcd - 2
    localparam G = 3'b001;  // Bcd - 1

    // Clock parameters
    parameter CLK_FREQ = 100_000_000; // 100 MHz

    // Timing parameters in seconds
    parameter G_min = 6'd60;
    parameter G_max = 7'd90;
    parameter Y_sec = 5'd10;

    // FSM States
    localparam S0 = 3'd0; // NS straight green
    localparam S1 = 3'd1; // NS straight yellow
    localparam S2 = 3'd2; // NS right green
    localparam S3 = 3'd3; // NS right yellow
    localparam S4 = 3'd4; // EW straight green
    localparam S5 = 3'd5; // EW straight yellow
    localparam S6 = 3'd6; // EW right green
    localparam S7 = 3'd7; // EW right yellow

    reg [2:0] curr, next;
    reg [7:0] sec_cnt;

    // 1-Second Clock Enable Generator
    reg [$clog2(CLK_FREQ)-1:0] clk_cnt;
    reg sec_tick;

    always @(posedge clk) begin
        if (rst) begin
            clk_cnt  <= 0;
            sec_tick <= 0;
        end else if (clk_cnt == CLK_FREQ-1) begin
            clk_cnt  <= 0;
            sec_tick <= 1;
        end else begin
            clk_cnt  <= clk_cnt + 1;
            sec_tick <= 0;
        end
    end

    // State register & second counter
    always @(posedge clk) begin
        if (rst) begin
            curr    <= S0;
            sec_cnt <= 0;
        end else if (sec_tick) begin
            curr <= next;
            if (curr != next)
                sec_cnt <= 0;
            else
                sec_cnt <= sec_cnt + 1;
        end
    end

    // Next-state logic
    always @(*) begin
        next = curr;
        case (curr)
            S0: if (sec_cnt >= G_min && (ew || sec_cnt >= G_max)) next = S1;
            S1: if (sec_cnt >= Y_sec) next = S2;
            S2: if (sec_cnt >= G_min) next = S3;
            S3: if (sec_cnt >= Y_sec) next = S4;
            S4: if (sec_cnt >= G_min && (ns || sec_cnt >= G_max)) next = S5;
            S5: if (sec_cnt >= Y_sec) next = S6;
            S6: if (sec_cnt >= G_min) next = S7;
            S7: if (sec_cnt >= Y_sec) next = S0;
            default: next = S0;
        endcase
    end

    // Output logic
    always @(*) begin
        NS_str   = R;
        NS_right = R;
        EW_str   = R;
        EW_right = R;

        case (curr)
            S0: NS_str   = G;
            S1: NS_str   = Y;
            S2: NS_right = G;
            S3: NS_right = Y;
            S4: EW_str   = G;
            S5: EW_str   = Y;
            S6: EW_right = G;
            S7: EW_right = Y;
        endcase
    end

endmodule
