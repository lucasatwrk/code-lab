module keypad #(parameter
    BASE_FREQ = 50_000_000,
    COLUMNS = 4,
    ROWS = 4
)(
    input logic clk,
    input logic [ROWS-1:0] row,
    output logic [COLUMNS-1:0] col,
    output logic [COLUMNS*ROWS-1:0] key
);
    logic [COLUMNS*ROWS-1:0] t_key;
    logic [$clog2(COLUMNS+1)-1:0] col_cnt = 0;
    logic [$clog2(ROWS+1)-1:0] row_cnt = 0;

    initial begin
        $display("$clog2(COLUMNS+1) = %d\n", $clog2(COLUMNS+1));
    end

    always_ff @ (posedge clk) begin
        if(col_cnt == COLUMNS - 1) begin
            col_cnt <= 0;
            if(row_cnt == ROWS - 1) begin
                row_cnt <= 0;
            end else begin
                row_cnt <= row_cnt + 1;
            end
        end else begin
            col_cnt <= col_cnt + 1;
        end
        $display("c: %d, r: %d, col: %B, row: %B, key: %B, key_idx: %d", col_cnt, row_cnt, col, row, t_key, (row_cnt * COLUMNS + col_cnt));
    end

    always_comb begin
        for(int c = 0; c < COLUMNS; c++) begin
            /* verilator lint_off WIDTHEXPAND */
            col[c] = (c == col_cnt) ? 0 : 1;  // low-active
        end
        /* verilator lint_off WIDTHTRUNC */
        t_key = !row[row_cnt] ? (1 << (row_cnt * COLUMNS + col_cnt)) : 0;
    end

    assign key = t_key;

endmodule
