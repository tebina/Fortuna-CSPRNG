
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity tb_fortuna_core is
end entity tb_fortuna_core;

architecture tb_arch of tb_fortuna_core is

  -- Component declaration for the DUT (Design Under Test)
  component fortuna_core is
    port (
      clk         : in    std_logic;
      rst         : in    std_logic;
      start       : in    std_logic;
      seed_data   : in    std_logic_vector(255 downto 0);
      random_data : out   std_logic_vector(127 downto 0);
      done        : out   std_logic
    );
  end component fortuna_core;

  -- Constants
  constant clk_period : time := 10 ns;  -- Clock period

  -- Signals
  signal clk         : std_logic                      := '0';
  signal rst         : std_logic                      := '0';
  signal start       : std_logic                      := '0';
  signal done        : std_logic;
  signal seed_data   : std_logic_vector(255 downto 0) := (others => '0');
  signal random_data : std_logic_vector(127 downto 0);

begin

  -- Instantiate the DUT
  dut : component fortuna_core
    port map (
      clk         => clk,
      rst         => rst,
      start       => start,
      seed_data   => seed_data,
      random_data => random_data,
      done        => done
    );

  -- Clock process
  clk_process : process is
  begin

    loop  -- Simulate for 1000 ns

      clk <= not clk;
      wait for clk_period / 2;

    end loop;

    wait;

  end process clk_process;

  -- Stimulus process
  stim_process : process is
  begin

    -- Apply reset
    rst <= '1';
    wait for 20 ns;
    rst <= '0';

    seed_data <= (others => '1');
    -- Wait for a few clock cycles
    wait for clk_period * 5;

    -- Start Fortuna core
    start <= '1';

    -- Wait for some time
    wait for clk_period * 1;

    start <= '0';
    -- Provide seed data

    -- Wait for some time
    wait for clk_period * 10;

    -- End simulation
    wait;

  end process stim_process;

end architecture tb_arch;
