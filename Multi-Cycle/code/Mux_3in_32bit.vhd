library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux3 is
  generic (
    n : integer := 32  -- Default to 32-bit width
  );
  port (
    -- input
    input_1    : in std_logic_vector(n - 1 downto 0);
    input_2    : in std_logic_vector(n - 1 downto 0);
    input_3    : in std_logic_vector(n - 1 downto 0);
    sel : in std_logic_vector(1 downto 0);

    -- output
    output     : out std_logic_vector(n - 1 downto 0)
  );
end Mux3;

architecture Behavioral of Mux3 is
  signal mux_out : std_logic_vector(n - 1 downto 0);
begin
  with sel select
    mux_out <= input_1                       when "00",
               input_2                       when "01",
               input_3                       when "10",
               (others => '0')               when others;

  output <= mux_out;
end Behavioral;