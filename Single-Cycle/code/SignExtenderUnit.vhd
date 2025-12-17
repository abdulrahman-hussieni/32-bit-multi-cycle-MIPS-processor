library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL;

entity SignExtenderUnit is
	port(
	input : in STD_LOGIC_Vector(15 downto 0);
	output : out STD_LOGIC_Vector(31 downto 0)
	);
end SignExtenderUnit;

architecture convert of SignExtenderUnit is
begin	 	
	output <= std_logic_vector(resize(signed(input),32));
end convert;


