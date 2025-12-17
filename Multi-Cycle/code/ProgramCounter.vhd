library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ProgramCounter is
  generic(
    ADDR_WIDTH : integer := 32
  );
  port(
    clk        : in  std_logic;
    rst        : in  std_logic;
    pc_in      : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    pc_write   : in  std_logic;
	
    pc_out     : out std_logic_vector(ADDR_WIDTH-1 downto 0)
  );
end ProgramCounter;

architecture Behavioral of ProgramCounter is
  signal pc_reg : std_logic_vector(ADDR_WIDTH-1 downto 0) := (others => '0');
begin
  process(clk)
  begin
    if rst = '0' then
      pc_reg <= (others => '0');
    elsif rising_edge(clk) then
      if pc_write = '1' then
        pc_reg <= pc_in;
      else
        pc_reg <= std_logic_vector(unsigned(pc_reg) + 4);  -- ÇáÒíÇÏÉ ÇáÊáÞÇÆíÉ
      end if;
    end if;
  end process;

  pc_out <= pc_reg;
end Behavioral;

  
