module aes_round_logic (
    input  wire [127:0] state_in,
    input  wire [127:0] round_key,
    input  wire         is_final_round,
    output wire [127:0] state_out
);

    wire [127:0] sub_bytes_out;
    wire [127:0] shift_row_out;
    wire [127:0] mix_columns_out;
    wire [127:0] add_key_in;

    sbox_128bit round_sbox(
        .state_in(state_in),
        .state_out(sub_bytes_out)
    );

    shift_row round_shift_row(
        .state_in(sub_bytes_out),
        .state_out(shift_row_out)
    );

    mix_column_128bit round_mix_column(
        .state_in(shift_row_out),
        .state_out(mix_columns_out)
    );

    assign add_key_in = is_final_round ? shift_row_out : mix_columns_out;

    add_round_key round_output(
        .state_in(add_key_in),
        .round_key(round_key),
        .state_out(state_out)
    );

endmodule