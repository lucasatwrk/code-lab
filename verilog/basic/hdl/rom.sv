module rom #(
    parameter DATA_WIDTH = 8,
    ADDR_WIDTH = 4,
    MEM_FILE = "rom_init.hex"
) (
    input logic [ADDR_WIDTH-1:0] addr,
    output logic [DATA_WIDTH-1:0] data
);
    logic [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH-1];

    initial begin
        $display("[ROM] Load file: %s", MEM_FILE);
        `ifdef BINARY_FILE
            $readmemb(MEM_FILE, mem);
        `else
            $readmemh(MEM_FILE, mem);
        `endif
    end
    assign data = mem[addr];
endmodule
