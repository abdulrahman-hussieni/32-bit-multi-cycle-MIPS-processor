library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegisterPairAb is
    Port (
        clk    : in STD_LOGIC;
        AIn    : in STD_LOGIC_VECTOR(31 downto 0);
        BIn    : in STD_LOGIC_VECTOR(31 downto 0);
        AOut   : out STD_LOGIC_VECTOR(31 downto 0);
        BOut   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end RegisterPairAb;

architecture Behavioral of RegisterPairAb is
    signal regA, regB : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            regA <= AIn;
            regB <= BIn;
        end if;
    end process;
    
    AOut <= regA;
    BOut <= regB;
end Behavioral;


