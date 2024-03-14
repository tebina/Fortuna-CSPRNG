
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use std.env.finish;

entity tb_mux2to1 is
end entity tb_mux2to1;

architecture testbench of tb_mux2to1 is

  -- Constants
  constant width   : natural := 256;
  constant timeout : time    := 1000 ns; -- Maximum simulation time

  -- Signals
  signal inputa    : std_logic_vector(width - 1 downto 0);
  signal inputb    : std_logic_vector(width - 1 downto 0);
  signal outputmux : std_logic_vector(width - 1 downto 0);
  signal sel       : std_logic;

  -- Component instantiation
  component mux2to1 is
    port (
      inputa    : in    std_logic_vector(width - 1 downto 0);
      inputb    : in    std_logic_vector(width - 1 downto 0);
      sel       : in    std_logic;
      outputmux : out   std_logic_vector(width - 1 downto 0)
    );
  end component mux2to1;

begin

  -- Instantiate the DUT
  dut : component mux2to1
    port map (
inputa,
 inputb,
 sel,
 outputmux
    );

  -- Test procedure
  process is

    variable error_count : integer := 0;

  begin

    inputa <= (others => '0');
    inputb <= (others => '1');
    sel    <= '0';

    wait for 10 ns;

    if (outputmux /= inputb) then
      report "Test 1 failed: Incorrect output for sel = 0";
      error_count := error_count + 1;
    end if;

    inputa <= (others => '1');
    inputb <= (others => '0');
    sel    <= '1';

    wait for 10 ns;

    if (outputmux /= inputa) then
      report "Test 2 failed: Incorrect output for sel = 1";
      error_count := error_count + 1;
    end if;

    if (error_count = 0) then
      report "All tests passed successfully ! ";
    else
      report integer'image(error_count) & " tests failed";
    end if;

    wait for 10 ns;
    report "Simulation completed";
    finish;

  end process;

  -- Ensure simulation doesn't hang
  process is
  begin

    wait for timeout;
    report "Simulation timeout reached";
    wait;

  end process;

end architecture testbench;
