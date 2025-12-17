library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ShiftLeft2 is
  generic (
    input_width  : integer := 26;
    output_width : integer := 28
  );
  port (
    -- input
    input  : in std_logic_vector(input_width - 1 downto 0);

    -- output
    output : out std_logic_vector(output_width - 1 downto 0)
  );
end ShiftLeft2;

architecture Behavioral of ShiftLeft2 is
begin
  output <= input & "00";
end Behavioral;