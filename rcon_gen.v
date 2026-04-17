module rcon_gen(
    input wire [2:0] index,
    output reg [7:0] rcon_value
);

    always @(*) begin
        case (index)
            3'b000: rcon_value = 8'h01;
            3'b001: rcon_value = 8'h02;
            3'b010: rcon_value = 8'h04;
            3'b011: rcon_value = 8'h08;
            3'b100: rcon_value = 8'h10;
            3'b101: rcon_value = 8'h20;
            3'b110: rcon_value = 8'h40;
            default: rcon_value = 8'h00;
        endcase
    end

endmodule