library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUControl is
  port(
    ALUOp  : in std_logic_vector(1 downto 0);
    instr  : in std_logic_vector(5 downto 0);
    result : out std_logic_vector(3 downto 0)
  );
end ALUControl;

architecture Behavioral of ALUControl is
begin
  process(ALUOp, instr)
  begin
    case ALUOp is
      when "00" =>
        result <= "0000"; -- addi for LW
      when "01" =>
        result <= "0110"; -- subi for Branch
      when "10" =>
        case instr is
          when "100000" => result <= "0001"; -- subtract
          when "100100" => result <= "0010"; -- AND
          when "100101" => result <= "0011"; -- OR
          when "100111" => result <= "0100"; -- NOR
          when "100110" => result <= "0101"; -- XOR
          when "000000" => result <= "0110"; -- shift left logical
          when "000010" => result <= "0111"; -- shift right logical
          when "101010" => result <= "1000"; -- set on less than
          when "001000" => result <= "1001"; -- add immediate
          when "001100" => result <= "1010"; -- AND immediate
          when "001101" => result <= "1011"; -- OR immediate 
          when "100010" => result <= "0000"; -- add
          when others   => result <= "1111";
        end case;
      when others =>
        result <= "1111";
    end case;
  end process;
end Behavioral;
