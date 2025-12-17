
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processor_TB is
end Processor_TB;

architecture behavior of Processor_TB is

-- Component Declaration for the Processor
component Processor
    port (
        clk : in std_logic;
        rst : in std_logic
    );
end component;

-- Signals to connect to the Processor
signal clk : std_logic := '0';
signal rst : std_logic := '0';

-- Internal signals for monitoring (to be observed in simulation tool)
-- These signals should be accessed via the simulation tool (e.g., ModelSim)
-- If needed, Processor.vhd can be modified to expose them as outputs
signal PC_out : std_logic_vector(31 downto 0);
signal InstructionRegOut : std_logic_vector(31 downto 0);
signal ReadData1ToA : std_logic_vector(31 downto 0);
signal ReadData2ToB : std_logic_vector(31 downto 0);
signal AluResultOut : std_logic_vector(31 downto 0);
signal ZeroCarry_TL : std_logic;
signal MuxToWriteRegister : std_logic_vector(4 downto 0);
signal MuxToWriteData : std_logic_vector(31 downto 0);
signal RegWrite_TL : std_logic;

-- Clock period
constant CLK_PERIOD : time := 10 ns;

-- Function to convert opcode to instruction name (for reporting)
function opcode_to_string(opcode : std_logic_vector(5 downto 0)) return string is
begin
    case opcode is
        when "100011" => return "lw   ";
        when "101011" => return "sw   ";
        when "000000" => return "R-type";
        when "001000" => return "addi ";
        when "000100" => return "beq  ";
        when "000010" => return "j    ";
        when others   => return "unknown";
    end case;
end function;

begin

-- Instantiate the Processor
uut: Processor
    port map (
        clk => clk,
        rst => rst
    );

-- Clock process: generates a 10 ns period clock for 100 cycles
clk_process : process
begin
    for i in 1 to 100 loop -- Run for 100 clock cycles
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end loop;
    report "Simulation completed after 100 clock cycles.";
    wait; -- Stop simulation
end process;

-- Reset process: activate reset for 20 ns, then release
rst_process : process
begin
    rst <= '0'; -- Reset active (active-low)
    wait for 20 ns;
    rst <= '1'; -- Release reset
    wait;
end process;


-- Assertions for verification
assert_process : process(clk)
begin
    if rising_edge(clk) and rst = '1' then
        -- Example: Check PC increment after reset
        if now > 20 ns then
            assert PC_out = std_logic_vector(to_unsigned(to_integer(unsigned(PC_out)) + 4, 32))
                report "PC did not increment correctly at time " & time'image(now)
                severity warning;
        end if;

        -- Check specific instruction results (based on Memory.vhd)
        -- addi $R1, $R3, 50 at address 4-7
        if InstructionRegOut(31 downto 26) = "001000" and now > 40 ns then
            assert ReadData1ToA = std_logic_vector(to_unsigned(50, 32))
                report "Register $R1 did not get value 50 after addi at time " & time'image(now)
                severity warning;
        end if;

        -- lw $R0, 47($R20) at address 0-3
        if InstructionRegOut(31 downto 26) = "100011" and now > 60 ns then
            assert ReadData1ToA = std_logic_vector(to_unsigned(1, 32))
                report "Register $R0 did not get value 1 after lw at time " & time'image(now)
                severity warning;
        end if;

        -- beq $R1, $R2, 1 at address 16-19
        if InstructionRegOut(31 downto 26) = "000100" and ZeroCarry_TL = '1' then
            report "Branch taken at time " & time'image(now);
        end if;
    end if;
end process;

end behavior;