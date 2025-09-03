module fan #(parameter int N_BITS = 4) (
    input [N_BITS - 1:0] a,
    input [N_BITS - 1:0] b,
    input cin,
    output [N_BITS - 1:0] sum,
    output cout
);

    wire [N_BITS:0] carry;
    assign carry[0] = cin;
    
    genvar i;
    generate
        for (i = 0; i < N_BITS; i = i + 1) begin : adder
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i + 1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate
    
    assign cout = carry[N_BITS];

endmodule