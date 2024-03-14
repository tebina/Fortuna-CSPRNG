library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;

entity counter is
  port (
    clk    : in    std_logic;
    rst    : in    std_logic;
    enable : in    std_logic;
    done   : out   std_logic;
    count  : out   std_logic_vector(127 downto 0)
  );
end entity counter;

architecture counter_behavioural of counter is

  signal count_signal : std_logic_vector(127 downto 0);

begin

  count_process : process (clk, rst, enable) is
  begin

    if (rst = '1') then
      count_signal <= (others => '0');
    elsif (clk'event and clk = '1' and enable = '1' and count_signal /= X"FFFFF") then
      count_signal <= count_signal + 1;
    else
      done <= '1';
    end if;

  end process count_process;

  count <= count_signal;

end architecture counter_behavioural;
