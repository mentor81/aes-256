module rot_word(
    input wire [31:0] in_word,
    output wire [31:0] out_word
);
    assign out_word = {in_word[23:0], in_word[31:24]};
endmodule