`timescale 1ns / 1ps




module trng32 (
    input clk,
    input en,
    output [31:0] R
);

  wire [31:0] R_signal;
  assign R = R_signal;

  trng trng_instance0 (
      .clk(clk),
      .en (en),
      .R  (R_signal[7:0])
  );
  trng trng_instance1 (
      .clk(clk),
      .en (en),
      .R  (R_signal[15:8])
  );
  trng trng_instance2 (
      .clk(clk),
      .en (en),
      .R  (R_signal[23:16])
  );
  trng trng_instance3 (
      .clk(clk),
      .en (en),
      .R  (R_signal[31:24])
  );

endmodule
