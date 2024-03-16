library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_unsigned.all;

entity fortuna_core is
  port (
    clk         : in    std_logic;
    rst         : in    std_logic;
    start       : in    std_logic;
    seed_data   : in    std_logic_vector(255 downto 0);
    done        : out   std_logic;
    random_data : out   std_logic_vector(127 downto 0)
  );
end entity fortuna_core;

architecture fortuna_structural of fortuna_core is

  component aes_core is
    port (
      clk    : in    std_logic;
      load_i : in    std_logic;
      key_i  : in    std_logic_vector(255 downto 0);
      data_i : in    std_logic_vector(127 downto 0);
      size_i : in    std_logic_vector(1 downto 0);
      dec_i  : in    std_logic;
      data_o : out   std_logic_vector(127 downto 0);
      busy_o : out   std_logic
    );
  end component aes_core;

  component counter is
    port (
      clk    : in    std_logic;
      rst    : in    std_logic;
      enable : in    std_logic;
      count  : out   std_logic_vector(127 downto 0)
    );
  end component counter;

  signal load_i_signal      : std_logic;
  signal key_i_buffer       : std_logic_vector(255 downto 0);
  signal counter_o_signal   : std_logic_vector(127 downto 0);
  signal data_o_buffer      : std_logic_vector(127 downto 0);
  signal enable_signal      : std_logic;
  signal random_data_signal : std_logic_vector(127 downto 0);
  signal encrypt_busy_o     : std_logic;
  signal encrypt_schedule   : integer range 0 to 3;

  type state_type is (idle, seed, increment, encrypt);

  signal current_state, next_state : state_type; -- mealy type state machine

  type buffer_type is array (0 to 2) of std_logic_vector(127 downto 0);

  signal cipher_buffer : buffer_type;

begin

  aes_instance : component aes_core
    port map (
      clk    => clk,
      load_i => load_i_signal,
      key_i  => key_i_buffer,
      data_i => counter_o_signal,
      size_i => "10",
      dec_i  => '0',
      data_o => data_o_buffer,
      busy_o => encrypt_busy_o
    );

  counter_instance : component counter
    port map (
      clk    => clk,
      rst    => rst,
      enable => enable_signal,
      count  => counter_o_signal
    );

  process (clk, rst) is
  begin

    if (rst = '1') then
      current_state <= idle;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;

  end process;

  process (current_state, start, encrypt_busy_o) is
  begin

    case current_state is

      when idle =>

        load_i_signal    <= '0';
        enable_signal    <= '0';
        encrypt_schedule <= 0;

        if (start = '1') then
          done <= '0';
          if (counter_o_signal = 0 or counter_o_signal = X"FFFFF") then
            next_state    <= seed;
            load_i_signal <= '0';
          else
            next_state    <= encrypt;
            load_i_signal <= '1';
          end if;
        end if;

      when seed =>

        enable_signal <= '1';
        load_i_signal <= '1';
        key_i_buffer  <= seed_data;
        next_state    <= encrypt;

      when encrypt =>

        load_i_signal <= '0';

        if falling_edge(encrypt_busy_o) then
          enable_signal                   <= '1';
          cipher_buffer(encrypt_schedule) <= data_o_buffer;
          encrypt_schedule                <= encrypt_schedule + 1;
          next_state                      <= increment;
        else
          enable_signal <= '0';
          load_i_signal <= '0';
          next_state    <= encrypt;
        end if;

      when increment =>

        enable_signal <= '0';
        load_i_signal <= '1';

        if (encrypt_schedule = 3) then
          done               <= '1';
          random_data_signal <= cipher_buffer(0);
          key_i_buffer       <= cipher_buffer(1) & cipher_buffer(2);
          next_state         <= idle;
        else
          next_state    <= encrypt;
          load_i_signal <= '1';
        end if;

    end case;

  end process;

  random_data <= random_data_signal;

end architecture fortuna_structural;

