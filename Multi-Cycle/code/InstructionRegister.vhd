library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstructionRegister is
  generic(
    DATA_WIDTH : integer := 32
  );
  port(
    clk             : in std_logic;
    rst             : in std_logic;
    ir_write        : in std_logic;
    instruction_in  : in std_logic_vector(DATA_WIDTH-1 downto 0); 
	
    instruction_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end InstructionRegister;

architecture Behavioral of InstructionRegister is
  signal instr_reg : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
begin
  process(clk)
  begin
    if rst = '0' then
      instr_reg <= (others => '0');
    elsif rising_edge(clk) and ir_write = '1' then
      instr_reg <= instruction_in;
    end if;
  end process;

  instruction_out <= instr_reg;
end Behavioral;