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

  count_process : process (clk, rst, enable, count_signal) is
  begin

    if (rst = '1') then
      count_signal <= (others => '0');
      done         <= '0';
    elsif (rising_edge(clk) and enable = '1') then
      if (count_signal = X"FFFFF") then
        done <= '1';
      else
        count_signal <= count_signal + 1;
      end if;
    end if;

  end process count_process;

  count <= count_signal;

end architecture counter_behavioural;
