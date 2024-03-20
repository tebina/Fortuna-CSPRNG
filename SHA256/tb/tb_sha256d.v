`default_nettype none


module tb_sha256d ();


  parameter CLK_HALF_PERIOD = 2;
  parameter CLK_PERIOD = 2 * CLK_HALF_PERIOD;

  reg tb_clk;
  reg tb_reset_n;
  reg [255:0] tb_clear_input;
  reg tb_init;
  wire tb_ready;
  wire [255:0] tb_hash;
  wire tb_hash_valid;
  reg [31 : 0] error_ctr;
  reg [31 : 0] tc_ctr;




  sha256d dut (
      .clk(tb_clk),
      .reset_n(tb_reset_n),
      .init(tb_init),
      .clear_input(tb_clear_input),
      .ready(tb_ready),
      .hash(tb_hash),
      .hash_valid(tb_hash_valid)
  );



  always begin : clk_gen
    #CLK_HALF_PERIOD tb_clk = !tb_clk;
  end  // clk_gen



  task reset_dut;
    begin
      $display("*** Toggle reset.");
      tb_reset_n = 0;
      #(4 * CLK_HALF_PERIOD);
      tb_reset_n = 1;
    end
  endtask  // reset_dut



  task init_sim;
    begin

      tb_clk = 0;
      tb_reset_n = 0;
      tb_init = 0;
      error_ctr = 0;
      tc_ctr = 0;
      tb_clear_input = 256'b0;
    end
  endtask  // init_dut


  task wait_ready;
    begin
      while (!tb_ready) begin
        #(CLK_PERIOD);
      end
    end
  endtask  // wait_ready


  task single_block_test(input [7 : 0] tc_number, input [255 : 0] block, input [255 : 0] expected);
    begin
      $display("*** TC %0d single block test case started.", tc_number);
      tc_ctr = tc_ctr + 1;

      tb_clear_input = block;
      tb_init = 1;
      #(CLK_PERIOD);
      wait_ready();


      if (tb_hash == expected) begin
        $display("*** TC %0d successful.", tc_number);
        $display("");
      end else begin
        $display("*** ERROR: TC %0d NOT successful.", tc_number);
        $display("Expected: 0x%064x", expected);
        $display("Got:      0x%064x", tb_hash);
        $display("");

        error_ctr = error_ctr + 1;
      end
    end
  endtask  // single_block_test


  task display_test_result;
    begin
      if (error_ctr == 0) begin
        $display("*** All %02d test cases completed successfully", tc_ctr);
      end else begin
        $display("*** %02d test cases did not complete successfully.", error_ctr);
      end
    end
  endtask  // display_test_result


  task sha256_core_test;
    reg [255 : 0] tc1;
    reg [255 : 0] res1;

    begin : sha256_core_test
      // TC1: Single block message: "abc".


      tc1  = 256'he3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855;
      res1 = 256'h5df6e0e2761359d30a8275058e299fcc0381534545f55cf43e41983f5d4c9456;
      single_block_test(1, tc1, res1);


    end
  endtask  // sha256_core_test


  initial begin : main
    $display("   -- Testbench for sha256 core started --");

    init_sim();
    reset_dut();

    sha256_core_test();

    display_test_result();
    $display("*** Simulation done.");
    $finish;
  end  // main

endmodule
