library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
  generic (
    n : integer := 32  -- ALU width
  );
  port (
    -- input
    operand_1   : in std_logic_vector(n - 1 downto 0);
    operand_2   : in std_logic_vector(n - 1 downto 0);
    ALU_control : in std_logic_vector(3 downto 0);  -- 12 operations (only some shown)

    -- output
    result      : out std_logic_vector(n - 1 downto 0);
    zero        : out std_logic
  );
end ALU;

architecture Behavioral of ALU is
  signal temp : std_logic_vector(n - 1 downto 0);
begin

  temp <=
    -- ADD
    std_logic_vector(unsigned(operand_1) + unsigned(operand_2)) when ALU_control = "0000" else
    -- SUB
    std_logic_vector(unsigned(operand_1) - unsigned(operand_2)) when ALU_control = "0001" else
    -- AND
    operand_1 and operand_2 when ALU_control = "0010" else
    -- OR
    operand_1 or operand_2 when ALU_control = "0011" else
    -- NOR
    not (operand_1 or operand_2) when ALU_control = "0100" else
    -- NAND
    not (operand_1 and operand_2) when ALU_control = "0101" else
    -- XOR
    operand_1 xor operand_2 when ALU_control = "0110" else
    -- SLL (shift left logical)
    std_logic_vector(shift_left(unsigned(operand_1), to_integer(unsigned(operand_2(n - 1 downto n - 5))))) when ALU_control = "0111" else
    -- SRL (shift right logical)
    std_logic_vector(shift_right(unsigned(operand_1), to_integer(unsigned(operand_2(n - 1 downto n - 5))))) when ALU_control = "1000" else
    -- Default
    (others => '0');

  zero <= '1' when temp = std_logic_vector(to_unsigned(0, n)) else '0';

  result <= temp;

end Behavioral;
