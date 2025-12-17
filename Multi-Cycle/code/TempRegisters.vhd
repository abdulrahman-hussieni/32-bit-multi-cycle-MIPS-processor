library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TempRegisters is
  generic(
    DATA_WIDTH : integer := 32
  );
  port(
    clk         : in  std_logic;
    rst         : in  std_logic;
    enable      : in  std_logic;
    in_reg_a    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    in_reg_b    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    in_alu_out  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
	
    out_reg_a   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    out_reg_b   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    out_alu_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end TempRegisters;

architecture Behavioral of TempRegisters is
  type registers is array (0 to 2) of std_logic_vector(DATA_WIDTH-1 downto 0);
  signal data : registers := (others => (others => '0'));
begin
  process(clk)
  begin
    if rst = '0' then
      data <= (others => (others => '0'));
    elsif rising_edge(clk) and enable = '1' then
      data(0) <= in_reg_a;
      data(1) <= in_reg_b;
      data(2) <= in_alu_out;
    end if;
  end process;

  out_reg_a   <= data(0);
  out_reg_b   <= data(1);
  out_alu_out <= data(2);
end Behavioral;