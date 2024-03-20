module trng_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns

    // Inputs
    reg clk;
    reg en;

    // Outputs
    wire [31:0] R;

    // Instantiate the TRNG module
    trng32 uut (
        .clk(clk),
        .en(en),
        .R(R)
    );

    // File declaration
    integer out_file;

    // Clock generation
    always #((CLK_PERIOD)/2) clk = ~clk;

    // Test stimulus
    initial begin
        // Open output file
        out_file = $fopen("trng_output.txt", "w");

        // Initialize inputs
        clk = 0;
        en = 1;

        // Wait for some time to stabilize
        #100;

        // Loop for the duration of the simulation
        repeat (100) begin
            // Write output to the console and the file
            $display("Current output: %h", R);
            $fdisplay(out_file, "Current output: %h", R);
            #((CLK_PERIOD)/2); // Wait for half a clock cycle
        end

        // Close output file
        $fclose(out_file);

        // Finish simulation
        $finish;
    end

endmodule
