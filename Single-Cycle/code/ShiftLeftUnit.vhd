library IEEE;
use IEEE.std_logic_1164.all;

entity ShiftLeftUnit is
	port(
	    input : in STD_LOGIC_VECTOR(31 downto 0);  
		output : out STD_LOGIC_VECTOR(31 downto 0)
	);
end ShiftLeftUnit;


architecture Behavioral of ShiftLeftUnit is
begin
	output <= input(29 downto 0) & "00";

end Behavioral;


