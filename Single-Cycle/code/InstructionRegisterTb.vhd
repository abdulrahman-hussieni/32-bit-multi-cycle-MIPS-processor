library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstructionRegisterTb is
end entity;

architecture tb of InstructionRegisterTb is
    signal clk       : std_logic := '0';
    signal reset     : std_logic := '1';
    signal enable    : std_logic := '0';
    signal IR_in     : std_logic_vector(31 downto 0) := (others => '0');
    signal Op_code   : std_logic_vector(31 downto 26);
    signal rs        : std_logic_vector(25 downto 21);
    signal rt        : std_logic_vector(20 downto 16);
    signal immediate : std_logic_vector(15 downto 0);
begin

    -- DUT
    DUT : entity work.InstructionRegister
    port map (
        clk       => clk,
        reset     => reset,
        enable    => enable,
        IR_in     => IR_in,
        Op_code   => Op_code,
        rs        => rs,
        rt        => rt,
        immediate => immediate
    );

    -- Clock
    clk <= not clk after 20 ns;

    -- Stimulus
    process
    begin
        -- Reset
        wait for 30 ns;
        reset <= '0';

        -- Instruction 1 (lw)
        IR_in  <= "10001101001010000000000000000100";
        enable <= '1';
        wait for 40 ns;
        enable <= '0';

        -- Instruction 2 (addi)
        wait for 40 ns;
        IR_in  <= "00100010011100100000000000001010";
        enable <= '1';
        wait for 40 ns;
        enable <= '0';

        wait;
    end process;

end architecture;


