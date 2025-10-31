module led_stream #(parameter
    BASE_FREQ = 50_000_000,
    ACTIVE_MS = 100,
    GROUP_SIZE = 4
) (
    input logic clk,
    input logic rst_n,
    output logic [GROUP_SIZE-1:0] on
);
    genvar i;
    generate
        for (i = 0; i < GROUP_SIZE; i = i + 1) begin : led_array
            led #(.BASE_FREQ(BASE_FREQ), .ACTIVE_MS(ACTIVE_MS), .GROUP_SIZE(GROUP_SIZE), .GROUP(i)) led_inst(.clk(clk), .rst_n(rst_n), .on(on[i]));
        end
    endgenerate
endmodule
