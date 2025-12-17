library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MemoryDataRegister is
  generic(
    DATA_WIDTH : integer := 32
  );
  port(
    clk        : in  std_logic;
    rst        : in  std_logic;
    mdr_write  : in  std_logic;
    mem_data   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
	
    mdr_out    : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end MemoryDataRegister;

architecture Behavioral of MemoryDataRegister is
  signal mem_data_reg : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
begin
  process(clk)
  begin
    if rst = '0' then
      mem_data_reg <= (others => '0');
    elsif rising_edge(clk) and mdr_write = '1' then
      mem_data_reg <= mem_data;
    end if;
  end process;

  mdr_out <= mem_data_reg;
end Behavioral;