library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignExtend is
  generic (
    input_width  : integer := 16;
    output_width : integer := 32
  );
  port (
    -- input
    input  : in std_logic_vector(input_width - 1 downto 0);

    -- output
    output : out std_logic_vector(output_width - 1 downto 0)
  );
end SignExtend;

architecture Behavioral of SignExtend is
begin

--   output <= "0000000000000000" & input when (input(15) = '0') else
--             "1111111111111111" & input;
-- easy way below abood 
  output <= std_logic_vector(resize(signed(input), output_width));
end Behavioral;