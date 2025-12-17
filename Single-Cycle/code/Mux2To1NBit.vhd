library IEEE;
use IEEE.std_logic_1164.all;

entity Mux2To1NBit is
	generic( n : integer);
	port(
		a : in STD_LOGIC_VECTOR(n-1 downto 0);
		b : in STD_LOGIC_VECTOR(n-1 downto 0);
		sel : in STD_LOGIC;
		output : out STD_LOGIC_VECTOR(n-1 downto 0)
	);
end entity;


architecture Behavioral of Mux2To1NBit is
begin
	output <= a when sel = '0' else b;

end architecture;


