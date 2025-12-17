library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux2 is
  generic (
    n : integer := 32  -- Default to 32-bit width
  );
  port (
    -- input
    input_1    : in std_logic_vector(n - 1 downto 0);
    input_2    : in std_logic_vector(n - 1 downto 0);
    sel : in std_logic;

    -- output
    output     : out std_logic_vector(n - 1 downto 0)
  );
end Mux2;

architecture Behavioral of Mux2 is
begin
  with sel select
    output <= input_1 when '0',
              input_2 when others;

end Behavioral;
