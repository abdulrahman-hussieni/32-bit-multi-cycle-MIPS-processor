library IEEE;
use IEEE.std_logic_1164.all;

entity AndGate1Bit is
	port(
		a : in STD_LOGIC;
		b : in STD_LOGIC;
		output : out STD_LOGIC
	);
end entity;


architecture Behavioral of AndGate1Bit is
begin
	output <= a and b;

end architecture;


