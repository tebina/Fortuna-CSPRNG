library ieee;
  use ieee.std_logic_1164.all;

entity mux2to1 is
  port (
    inputa    : in    std_logic_vector(255 downto 0);
    inputb    : in    std_logic_vector(255 downto 0);
    sel       : in    std_logic;
    outputmux : out   std_logic_vector(255 downto 0)
  );
end entity mux2to1;

architecture behavioural of mux2to1 is

begin

  mux_process : process (inputa, inputb, sel) is
  begin

    if (sel = '1') then
      outputmux <= inputa;
    else
      outputmux <= inputb;
    end if;

  end process mux_process;

end architecture behavioural;

