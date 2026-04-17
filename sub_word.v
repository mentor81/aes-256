module sub_word(
    input wire [31:0] state_in,
    output wire [31:0] state_out
);

    genvar i;
    generate
        for (i = 0; i < 4; i = i+ 1) begin : gen_sbox
            sbox_8bit sbox(
                .in_byte(state_in[(i * 8) + 7 : i*8]),
                .out_byte(state_out[(i * 8) + 7 : i*8])
            );
        end
    endgenerate
    
endmodule