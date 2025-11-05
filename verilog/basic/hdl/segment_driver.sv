module segment_driver #(parameter
    BASE_FREQ = 50_000_000,
    ACTIVE_RATE = 100,
    DIGITS = 6,
    LOW_ACTIVE = 0
)(
    input logic clk,
    input logic [$clog2(10**DIGITS)-1:0] num,
    input logic [DIGITS-1:0] dp,
    output logic [7:0] dig,
    output logic [DIGITS-1:0] sel
);
    localparam ACTIVE_CYCLE = BASE_FREQ / ACTIVE_RATE;
    localparam FULL_CYCLE = ACTIVE_CYCLE * DIGITS;

    logic [31:0] counter = 0;
    logic [3:0] c_num;
    logic [$clog2(DIGITS):0] c_dig;
    logic [DIGITS-1:0] c_sel;
    logic [7:0] c_seg;
    assign dig = LOW_ACTIVE ? ~c_seg : c_seg;
    assign sel = LOW_ACTIVE ? ~c_sel : c_sel;
    segment_bcd_encoder sbe (.num(c_num), .seg(c_seg[6:0]));

    logic [31:0] divisor;

    always_ff @ (posedge clk) begin
        $display("[%d] num: %d, c_dig: %d, c_sel: %d, c_num: %d", counter, num, c_dig, c_sel, c_num);
        if(counter >= FULL_CYCLE - 1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

    always_comb begin
        /* verilator lint_off WIDTHTRUNC */
        c_dig = counter / ACTIVE_CYCLE;
        c_sel = 1 << c_dig;
        /* verilator lint_off WIDTHTRUNC */
        divisor = 1;
        for (int i = 0; i < c_dig; i++) begin
            divisor = (divisor << 3) + (divisor << 1);  // divisor * 10 (avoid using multiplication)
        end
        /* verilator lint_off WIDTHEXPAND */
        c_num = (num / divisor) % 10;
        c_seg[7] = dp[c_dig];
    end

endmodule

module segment_bcd_encoder (
    input logic [3:0] num,
    output logic [6:0] seg
);
    always_comb begin
        case (num)
            4'h0: seg = 7'h3f;
            4'h1: seg = 7'h06;
            4'h2: seg = 7'h5b;
            4'h3: seg = 7'h4f;
            4'h4: seg = 7'h66;
            4'h5: seg = 7'h6d;
            4'h6: seg = 7'h7d;
            4'h7: seg = 7'h07;
            4'h8: seg = 7'h7f;
            4'h9: seg = 7'h6f;
            4'ha: seg = 7'h77;
            4'hb: seg = 7'h7c;
            4'hc: seg = 7'h39;
            4'hd: seg = 7'h5e;
            4'he: seg = 7'h79;
            4'hf: seg = 7'h71;
            default: seg = 0;
        endcase
    end

endmodule
