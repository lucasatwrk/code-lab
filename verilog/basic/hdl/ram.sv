module ram #(
    parameter DATA_WIDTH = 8,
    ADDR_WIDTH = 12
) (
    input logic clk,
    input logic rst,
    input logic we,
    input logic [DATA_WIDTH-1:0] din,
    input logic [ADDR_WIDTH-1:0] addr,
    output logic [DATA_WIDTH-1:0] dout
);
    logic [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];
    always_ff @(posedge clk or negedge rst) begin
        if (~rst) begin
            for (int i = 0; i < 2**ADDR_WIDTH; i++) begin
                mem[i] <= 0;
            end
        end else begin
            if (we) begin
                mem[addr] <= din;
            end
        end
    end

    assign dout = mem[addr];
endmodule
