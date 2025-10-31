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
    always_ff @(posedge clk or negedge rst_n ) begin
        /* verilator lint_off UNSIGNED */
        /* verilator lint_off WIDTHEXPAND */
        if (~rst_n || (counter >= FULL_CYCLE)) begin
            counter <= 0;
        /* verilator lint_off UNSIGNED */
        /* verilator lint_off WIDTHEXPAND */
        end else if (counter >= GROUP * ACTIVE_CYCLE && counter < (GROUP + 1) * ACTIVE_CYCLE) begin
            on <= 1;
            counter <= counter + 1;
        end else begin
            on <= 0;
            counter <= counter + 1;
        end
    end

endmodule
