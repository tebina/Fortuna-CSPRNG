
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_counter is
end entity tb_counter;

architecture testbench of tb_counter is
  -- Constants
  constant CLOCK_PERIOD : time := 10 ns; -- Clock period
  constant TIMEOUT : time := 1000 ns;     -- Maximum simulation time

  -- Signals
  signal clk, rst, enable, done : std_logic;
  signal count : std_logic_vector(127 downto 0);

  -- Clock process
  process
  begin
    while not Stop_Simulation loop
      clk <= '0';
      wait for CLOCK_PERIOD / 2;
      clk <= '1';
      wait for CLOCK_PERIOD / 2;
    end loop;
    wait;
  end process;

  -- Test process
  process
  begin
    -- Reset and enable counter
    rst <= '1';
    enable <= '0';
    wait for 20 ns;
    rst <= '0';
    enable <= '1';

    -- Wait for some cycles
    wait for 200 ns;

    -- Disable counter
    enable <= '0';

    -- Wait for some cycles
    wait for 50 ns;

    -- Re-enable counter
    enable <= '1';

    -- Wait for some cycles
    wait for 300 ns;

    -- Verify if the count is correct
    if count /= X"00000000000000000000000000000000" then
      report "Test failed: Counter output incorrect after enable";
    end if;

    wait for done = '1';
    -- Report test completion
    report "Test completed successfully";
    wait;
  end process;

  -- Stop simulation process
  function Stop_Simulation return boolean is
  begin
    if now > TIMEOUT then
      report "Simulation timeout reached";
      return true;
    else
      return false;
    end if;
  end function;

begin
  -- Instantiate DUT
  dut: entity work.counter
    port map (
      clk => clk,
      rst => rst,
      enable => enable,
      done => done,
      count => count
    );

  -- Monitor outputs if needed
  -- Add code here if you want to monitor outputs during simulation

end architecture testbench;
