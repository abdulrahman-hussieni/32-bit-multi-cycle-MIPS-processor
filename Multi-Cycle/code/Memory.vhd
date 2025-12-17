library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory is
  generic(
    ADDR_WIDTH : integer := 32;
    DATA_WIDTH : integer := 32;
    MEM_SIZE   : integer := 64
  );
  port(
    clk        : in std_logic;
    rst        : in std_logic;
    address    : in std_logic_vector(ADDR_WIDTH-1 downto 0);
    mem_write  : in std_logic;
    mem_read   : in std_logic;
    write_data : in std_logic_vector(DATA_WIDTH-1 downto 0);
	
    mem_data   : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end Memory;

architecture Behavioral of Memory is
  type mem_type is array (0 to MEM_SIZE-1) of std_logic_vector(7 downto 0);
  signal mem: mem_type := (
   -- lw $R0,47($R20)
0 => "10001110",
1 => "10000000",
2 => "00000000",
3 => "00101111",

-- addi $R1,$R3,50
4 => "00100000",
5 => "01100001",
6 => "00000000",
7 => "00110010",

-- addi $R2,$R3,48
8 => "00100000",
9 => "01100010",
10 => "00000000",
11 => "00110000",

-- add $R2,$R2,$R0
12 => "00000000",
13 => "01000000",
14 => "00010000",
15 => "00100000",

-- beq $R1,$R2,1
16 => "00010000",
17 => "00100010",
18 => "00000000",
19 => "00000001",

-- j 3
20 => "00001000",
21 => "00000000",
22 => "00000000",
23 => "00000011",

-- add $R0,$R1,$R2
24 => "00000000",
25 => "00100010",
26 => "00000000",
27 => "00100000",

-- lw $R10,47($R20)
28 => "10001110",
29 => "10001010",
30 => "00000000",
31 => "00101111",

50 => "00000001",

others => "00000000" );
  
  signal addr_int : integer range 0 to MEM_SIZE-1;
begin
  process(clk)
  begin
    if rising_edge(clk) and mem_write = '1' then
      addr_int <= to_integer(unsigned(address));
      if addr_int + 3 < MEM_SIZE then
        mem(addr_int)     <= write_data(31 downto 24);
        mem(addr_int + 1) <= write_data(23 downto 16);
        mem(addr_int + 2) <= write_data(15 downto 8);
        mem(addr_int + 3) <= write_data(7 downto 0);
      end if;
    end if;
  end process;
  
  process(address, mem_read, mem)
    variable addr_int_read : integer range 0 to MEM_SIZE-1;
  begin
    if mem_read = '1' then
      addr_int_read := to_integer(unsigned(address));
      if addr_int_read + 3 < MEM_SIZE then
        mem_data <= mem(addr_int_read) & mem(addr_int_read + 1) & 
                    mem(addr_int_read + 2) & mem(addr_int_read + 3);
      else
        mem_data <= (others => '0');
      end if;
    else
      mem_data <= (others => '0');
    end if;
  end process;
end Behavioral;