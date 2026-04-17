module key_expand_256 (
    input  wire [255:0] key_in,
    input  wire [7:0]   rcon,
    output wire [255:0] key_out
);

    wire [31:0] w0, w1, w2, w3, w4, w5, w6, w7;
    assign {w0, w1, w2, w3, w4, w5, w6, w7} = key_in;

    wire [31:0] rot_w7, sub_rot_w7, sub_w11;
    
    wire [31:0] w8, w9, w10, w11, w12, w13, w14, w15;

    rot_word rw (
        .in_word(w7), 
        .out_word(rot_w7)
    );

    sub_word sw1 (
        .state_in(rot_w7), 
        .state_out(sub_rot_w7)
    );

    assign w8 = w0 ^ sub_rot_w7 ^ {rcon, 24'h000000};

    assign w9  = w1 ^ w8;
    assign w10 = w2 ^ w9;
    assign w11 = w3 ^ w10;

    sub_word sw2 (
        .state_in(w11), 
        .state_out(sub_w11)
    );

    assign w12 = w4 ^ sub_w11;

    assign w13 = w5 ^ w12;
    assign w14 = w6 ^ w13;
    assign w15 = w7 ^ w14;
    
    assign key_out = {w8, w9, w10, w11, w12, w13, w14, w15};

endmodule
