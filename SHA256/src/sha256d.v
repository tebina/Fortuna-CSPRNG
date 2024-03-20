`default_nettype none

module sha256d (
    input wire clk,
    input wire reset_n,

    input wire init,
    input wire [255 : 0] clear_input,

    output wire ready,
    output wire [255 : 0] hash,
    output wire hash_valid
);

  localparam PADDING = 256'h8000000000000000000000000000000000000000000000000000000000000100;

  localparam IDLE = 2'b00;
  localparam FIRST_ENCRYPT = 2'b01;
  localparam SECOND_ENCRYPT = 2'b10;
  reg  [  1:0] state_reg;
  reg  [  1:0] next_state;

  reg          local_reset_n;
  reg          local_init;
  wire         local_ready;
  reg  [511:0] block_signal;
  wire [255:0] local_hash;
  reg  [255:0] final_hash;
  reg          final_ready;


  assign hash  = final_hash;
  assign ready = final_ready;

  sha256_core sha256_instance (
      .clk(clk),
      .reset_n(reset_n),
      .init(local_init),
      .next(1'b0),
      .mode(1'b1),
      .block(block_signal),
      .ready(local_ready),
      .digest(local_hash),
      .digest_valid(hash_valid)
  );

  always @(state_reg or posedge init or local_ready) begin
    case (state_reg)
      IDLE: begin
        local_init   <= 0;
        block_signal <= 0;
        final_ready  <= 0;
        if (init) begin
          next_state   <= FIRST_ENCRYPT;
          local_init   <= 1;
          final_hash   <= 0;
          block_signal <= {clear_input, PADDING};
        end else next_state <= IDLE;
      end
      FIRST_ENCRYPT: begin
        local_init <= 0;
        if (local_ready) begin
          next_state   <= SECOND_ENCRYPT;
          block_signal <= {local_hash, PADDING};
        end else next_state <= FIRST_ENCRYPT;
      end
      SECOND_ENCRYPT: begin
        local_init <= 1;
        if (local_ready) begin
          next_state  <= IDLE;
          final_hash  <= local_hash;
          final_ready <= 1;
        end else next_state <= SECOND_ENCRYPT;
      end
      default: next_state <= IDLE;
    endcase
  end

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      state_reg <= IDLE;
    end else state_reg <= next_state;
  end



endmodule
