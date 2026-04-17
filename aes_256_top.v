module aes_256_top (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         start,
    input  wire [127:0] plain_text,
    input  wire [255:0] master_key,
    
    output reg  [127:0] cipher_text,
    output reg          done
);

    localparam s_IDLE = 2'b00;
    localparam s_RUN  = 2'b01;
    localparam s_DONE = 2'b10;

    reg [1:0] current_state;
    reg [3:0] round_counter;
    reg [2:0] rcon_counter;

    reg [127:0] state_reg;
    reg [255:0] key_reg;
    
    wire [127:0] next_state_data;
    wire         is_last_round = (round_counter == 4'd14);
    
    wire [7:0]   rcon_value;
    wire [255:0] expanded_key;
    wire [127:0] current_128bit_round_key; 
    
    rcon_gen aes_rcon(
        .index(rcon_counter),
        .rcon_value(rcon_value)
    );
    
    key_expand_256 key_schedule(
        .key_in(key_reg),
        .rcon(rcon_value),
        .key_out(expanded_key)
    );
    
    assign current_128bit_round_key = (round_counter[0] == 1'b1) ? key_reg[127:0] : expanded_key[255:128];
    
    aes_round_logic round_logic_inst (
        .state_in(state_reg),
        .round_key(current_128bit_round_key),
        .is_final_round(is_last_round),
        .state_out(next_state_data)
    );
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= s_IDLE;
            round_counter <= 4'd0; 
            rcon_counter  <= 3'd0; 
            cipher_text   <= 128'd0;
            done          <= 1'b0;
            state_reg     <= 128'd0;
            key_reg       <= 256'd0;
        end else begin
            case (current_state)
                s_IDLE: begin
                    done <= 1'b0;
                    if (start == 1'b1) begin
                        current_state <= s_RUN;
                        round_counter <= 4'd1; 
                        rcon_counter  <= 3'd0;

                        state_reg <= plain_text ^ master_key[255:128];
                        key_reg   <= master_key;
                    end
                end
                
                s_RUN: begin
                    state_reg <= next_state_data;
                    
                    if (round_counter == 4'd14) begin
                        current_state <= s_DONE;
                    end else begin
                        round_counter <= round_counter + 1'b1;

                        if (round_counter[0] == 1'b0) begin
                            key_reg      <= expanded_key;
                            rcon_counter <= rcon_counter + 1'b1;
                        end
                    end
                end
                
                s_DONE: begin
                    current_state <= s_IDLE;
                    done <= 1'b1;
                    cipher_text <= state_reg;
                end
                
                default: current_state <= s_IDLE;
            endcase
        end
    end
endmodule
