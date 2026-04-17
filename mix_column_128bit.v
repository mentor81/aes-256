module mix_column_128bit(
    input wire [127:0] state_in,
    output wire [127:0] state_out
);

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_mix_col
            mix_column_32bit mc (
                .col_in( state_in[(i*32)+31 : i*32] ),
                .col_out( state_out[(i*32)+31 : i*32] )
            );
        end
    endgenerate

endmodule