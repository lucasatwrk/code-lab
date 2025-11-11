module hex_keypad #(parameter
    BASE_FREQ = 50_000_000
)(
    input logic clk,
    input logic [3:0] row,
    output logic [3:0] col,
    output logic [3:0] key_code,
    output logic key_valid
);
    logic [15:0] key;
    keypad #(.BASE_FREQ(BASE_FREQ), .COLUMNS(4), .ROWS(4)) kp (.clk(clk), .row(row), .col(col), .key(key));

    always_comb begin
        case ({~col, ~row})
            8'b0001_0001: key_code = 4'h1;
            8'b0001_0010: key_code = 4'h4;
            8'b0001_0100: key_code = 4'h7;
            8'b0001_1000: key_code = 4'hE;  // *

            8'b0010_0001: key_code = 4'h2;
            8'b0010_0010: key_code = 4'h5;
            8'b0010_0100: key_code = 4'h8;
            8'b0010_1000: key_code = 4'h0;

            8'b0100_0001: key_code = 4'h3;
            8'b0100_0010: key_code = 4'h6;
            8'b0100_0100: key_code = 4'h9;
            8'b0100_1000: key_code = 4'hF;  // #

            8'b1000_0001: key_code = 4'hA;
            8'b1000_0010: key_code = 4'hB;
            8'b1000_0100: key_code = 4'hC;
            8'b1000_1000: key_code = 4'hD;
            default: key_code = 4'h0;
        endcase
    end

endmodule