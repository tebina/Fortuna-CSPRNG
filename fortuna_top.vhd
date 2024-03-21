library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.std_logic_unsigned.all;

entity fortuna_top is
  port (
    clk         : in    std_logic;
    rst         : in    std_logic;
    start       : in    std_logic;
    seed_data   : in    std_logic_vector(255 downto 0);
    done        : out   std_logic;
    random_data : out   std_logic_vector(127 downto 0)
  );
end entity fortuna_top;

architecture fortuna_top_structural of fortuna_top is

  component fortuna_core is
    port (
      clk         : in    std_logic;
      rst         : in    std_logic;
      start       : in    std_logic;
      seed_data   : in    std_logic_vector(255 downto 0);
      done        : out   std_logic;
      random_data : out   std_logic_vector(127 downto 0)
    );
  end component fortuna_core;

  component sha256d is
    port (
      clk         : in    std_logic;
      reset_n     : in    std_logic;
      init        : in    std_logic;
      clear_input : in    std_logic_vector(255 downto 0);
      ready       : out   std_logic;
      hash        : out   std_logic_vector(255 downto 0);
      hash_valid  : out   std_logic
    );
  end component sha256d;

  signal local_hashed_seed  : std_logic_vector(255 downto 0);
  signal local_sampled_seed : std_logic_vector(255 downto 0);
  signal local_sha_start    : std_logic;
  signal local_fcore_start  : std_logic;
  signal local_sha_done     : std_logic;
  signal local_fcore_done   : std_logic;
  signal reset_np           : std_logic;

  type state_type is (idle, hash_seed, encrypt_seed);

  signal current_state, next_state : state_type;

begin

  fortuna_core_inst : component fortuna_core
    port map (
      clk         => clk,
      rst         => rst,
      start       => local_fcore_start,
      seed_data   => local_sampled_seed,
      done        => local_fcore_done,
      random_data => random_data
    );

  sha256d_inst : component sha256d
    port map (
      clk         => clk,
      reset_n     => reset_np,
      init        => local_sha_start,
      clear_input => seed_data,
      ready       => local_sha_done,
      hash        => local_hashed_seed,
      hash_valid  => open
    );

  process (clk, rst) is
  begin

    if (rst = '1') then
      current_state <= idle;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;

  end process;

  process (current_state, start, local_fcore_done, local_sha_done) is
  begin

    case current_state is

      when idle =>

        local_fcore_start  <= '0';
        local_sha_start    <= '0';
        local_sampled_seed <= (others => '0');

        if (start = '1') then
          local_sha_start <= '1';
          next_state      <= hash_seed;
        else
          next_state <= idle;
        end if;

      when hash_seed =>

        if (local_sha_done = '1') then
          local_sha_start    <= '0';
          local_sampled_seed <= local_hashed_seed;
          local_fcore_start  <= '1';
          next_state         <= encrypt_seed;
        else
          next_state <= hash_seed;
        end if;

      when encrypt_seed =>

        if (local_fcore_done = '1') then
          local_fcore_start <= '0';
          next_state        <= idle;
        else
          next_state <= encrypt_seed;
        end if;

    end case;

  end process;

  done     <= local_fcore_done;
  reset_np <= not(rst);

end architecture fortuna_top_structural;

