module mix_column_32bit (
    input  wire [31:0] col_in,
    output wire [31:0] col_out
);

    wire [7:0] c0, c1, c2, c3;
    wire [7:0] r0, r1, r2, r3;

    assign c0 = col_in[31:24];
    assign c1 = col_in[23:16];
    assign c2 = col_in[15:8];
    assign c3 = col_in[7:0];

    function [7:0] gm2;
        input [7:0] x;
        begin
            gm2 = {x[6:0], 1'b0} ^ (x[7] ? 8'h1b : 8'h00);
        end
    endfunction

    assign r0 = gm2(c0) ^ (gm2(c1) ^ c1) ^ c2 ^ c3;
    assign r1 = c0 ^ gm2(c1) ^ (gm2(c2) ^ c2) ^ c3;
    assign r2 = c0 ^ c1 ^ gm2(c2) ^ (gm2(c3) ^ c3);
    assign r3 = (gm2(c0) ^ c0) ^ c1 ^ c2 ^ gm2(c3);

    assign col_out = {r0, r1, r2, r3};

endmodule
