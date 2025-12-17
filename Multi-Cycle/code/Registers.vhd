library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Registers is
  generic(
    ADDR_WIDTH : integer := 5;
    DATA_WIDTH : integer := 32;
    REG_COUNT  : integer := 32
  );
  port(
    clk          : in  std_logic;
    rst          : in  std_logic;
    address_in_1 : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    address_in_2 : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    write_reg    : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    write_data   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    reg_write    : in  std_logic;
	
    register_1   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    register_2   : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end Registers;

architecture Behavioral of Registers is
  type registers_type is array (0 to REG_COUNT-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
  signal reg : registers_type := (others => (others => '0'));
  
  signal reg_addr_1 : integer range 0 to REG_COUNT-1;
  signal reg_addr_2 : integer range 0 to REG_COUNT-1;
  signal reg_addr_w : integer range 0 to REG_COUNT-1;
begin
  reg_addr_1 <= to_integer(unsigned(address_in_1));
  reg_addr_2 <= to_integer(unsigned(address_in_2));
  reg_addr_w <= to_integer(unsigned(write_reg));

  process(clk)
  begin
    if rst = '0' then
      for i in 0 to REG_COUNT-1 loop
        reg(i) <= (others => '0');
      end loop;
    elsif rising_edge(clk) and reg_write = '1' then
      if reg_addr_w /= 0 then  -- Register 0 is always 0
        reg(reg_addr_w) <= write_data;
      end if;
    end if;
  end process;

  register_1 <= reg(reg_addr_1);
  register_2 <= reg(reg_addr_2);
end Behavioral;