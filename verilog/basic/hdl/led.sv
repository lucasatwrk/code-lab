module led #(parameter
    BASE_FREQ = 50_000_000,
    ACTIVE_MS = 100,
    GROUP_SIZE = 4,
    GROUP = 0
)(
    input logic clk,
    input logic rst_n,
    output logic on
);
    localparam ACTIVE_CYCLE = BASE_FREQ / 1000 * ACTIVE_MS;
    localparam FULL_CYCLE = ACTIVE_CYCLE * GROUP_SIZE;

    logic [25:0] counter;
    logic in_active_window;

    assign in_active_window =
        /* verilator lint_off WIDTHEXPAND */
        /* verilator lint_off UNSIGNED */
        (counter >= GROUP * ACTIVE_CYCLE) &&
        (counter < (GROUP + 1) * ACTIVE_CYCLE);

    always_ff @(posedge clk or negedge rst_n ) begin
        /* verilator lint_off UNSIGNED */
        /* verilator lint_off WIDTHEXPAND */
        if (~rst_n) begin
            counter <= 0;
            on <= 0;
        end else begin
            /* verilator lint_off UNSIGNED */
            /* verilator lint_off WIDTHEXPAND */
            if (counter >= FULL_CYCLE - 1) begin
                counter <= 0;
                on <= 0;
            end
            else begin
                counter <= counter + 1;
                on <= in_active_window;
            end
        end
    end

endmodule
