library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use std.env.finish;

entity tb_counter is
end entity tb_counter;

architecture sim of tb_counter is

  constant clock_period : time      := 10 ns;             -- Define clock period
  signal   clk          : std_logic := '0';
  signal   rst          : std_logic := '0';
  signal   enable       : std_logic := '0';
  signal   done         : std_logic := '0';               -- Signals for the testbench
  signal   count        : std_logic_vector(127 downto 0); -- Signal for the counter output

begin

  -- Instantiate the counter entity
  dut : entity work.counter
    port map (
      clk    => clk,
      rst    => rst,
      enable => enable,
      done   => done,
      count  => count
    );

  -- Clock process
  clk_process : process is
  begin

    loop -- Run the clock for 1000 ns

      clk <= '0';
      wait for clock_period / 2;
      clk <= '1';
      wait for clock_period / 2;

    end loop;

    wait;

  end process clk_process;

  -- Stimulus process
  stimulus_process : process is
  begin

    -- Reset
    rst    <= '1';
    enable <= '0';
    wait for 20 ns;
    rst    <= '0';
    wait for 10 ns;

    -- Enable counter
    enable <= '1';
    wait for 500 ns;

    -- Reset again
    rst <= '1';
    wait for 10 ns;
    rst <= '0';

    wait;

  end process stimulus_process;

  -- Monitor process
  monitor_process : process is
  begin

    wait until done = '1'; -- Wait until counter is done
    report "Simulation finished successfully ! "
      severity note;
    finish;

  end process monitor_process;

end architecture sim;

