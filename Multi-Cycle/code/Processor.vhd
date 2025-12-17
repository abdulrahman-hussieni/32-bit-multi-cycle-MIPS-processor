library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processor is
  port (
    CLK, rst : in std_logic
  );
end Processor;

architecture Behavioral of Processor is
  -- Constant for PC increment
  constant PC_increment : std_logic_vector(31 downto 0) := "00000000000000000000000000000100";

  -- Internal signals
  signal PC_out, MuxToAddress, MemDataOut, MemoryDataRegOut, InstructionRegOut : std_logic_vector(31 downto 0);
  signal MuxToWriteData, ReadData1ToA, ReadData2ToB, RegAToMux, RegBOut : std_logic_vector(31 downto 0);
  signal SignExtendOut, ShiftLeft1ToMux4, MuxToAlu, Mux4ToAlu, AluResultOut : std_logic_vector(31 downto 0);
  signal AluOutToMux, JumpAddress, MuxToPC, full_jump_address : std_logic_vector(31 downto 0);
  signal MuxToWriteRegister : std_logic_vector(4 downto 0);
  signal ALUControltoALU : std_logic_vector(3 downto 0);
  signal PCsource_TL, ALUSrcB_TL, ALUOp_TL : std_logic_vector(1 downto 0);
  signal ZeroCarry_TL, ALUSrcA_TL, RegWrite_TL, RegDst_TL, PCWriteCond_TL : std_logic;
  signal PCWrite_TL, IorD_TL, MemRead_TL, MemWrite_TL, MemToReg_TL, IRWrite_TL : std_logic;
  signal ANDtoOR, ORtoPC, MDRWrite_TL : std_logic;

begin
  -- PC control logic
  ANDtoOR <= ZeroCarry_TL and PCWriteCond_TL;
  ORtoPC <= ANDtoOR or PCWrite_TL;

  -- Jump address concatenation
  full_jump_address <= PC_out(31 downto 28) & JumpAddress(27 downto 0);

  -- MDRWrite control (active during MemoryReadCompletionStep for load instructions)
  MDRWrite_TL <= '1' when MemToReg_TL = '1' else '0';

  -- Component instantiations
  -- ALU
  A_Logic_Unit : entity work.ALU(Behavioral)
    generic map ( n => 32 )
    port map (
      operand_1   => MuxToAlu,
      operand_2   => Mux4ToAlu,
      ALU_control => ALUControltoALU,
      result      => AluResultOut,
      zero        => ZeroCarry_TL
    );

  -- ALU Control
  ALU_CONTROL : entity work.ALUControl(Behavioral)
    port map (
      ALUOp  => ALUOp_TL,
      instr  => InstructionRegOut(5 downto 0),
      result => ALUControltoALU
    );

  -- Control Unit
  CTRL_UNIT : entity work.ControlUnit(Behavioral)
    port map (
      CLK         => CLK,
      Reset       => rst,
      Op          => InstructionRegOut(31 downto 26),
      PCWriteCond => PCWriteCond_TL,
      PCWrite     => PCWrite_TL,
      IorD        => IorD_TL,
      MemRead     => MemRead_TL,
      MemWrite    => MemWrite_TL,
      MemToReg    => MemToReg_TL,
      IRWrite     => IRWrite_TL,
      PCSource    => PCsource_TL,
      ALUOp       => ALUOp_TL,
      ALUSrcB     => ALUSrcB_TL,
      ALUSrcA     => ALUSrcA_TL,
      RegWrite    => RegWrite_TL,
      RegDst      => RegDst_TL
    );

  -- Instruction Register
  INSTR_REG : entity work.InstructionRegister(Behavioral)
    generic map ( DATA_WIDTH => 32 )
    port map (
      clk             => CLK,
      rst             => rst,
      ir_write        => IRWrite_TL,
      instruction_in  => MemDataOut,
      instruction_out => InstructionRegOut
    );

  -- Memory
  MEM : entity work.Memory(Behavioral)
    generic map (
      ADDR_WIDTH => 32,
      DATA_WIDTH => 32,
      MEM_SIZE   => 64
    )
    port map (
      clk        => CLK,
      rst        => rst,
      address    => MuxToAddress,
      mem_write  => MemWrite_TL,
      mem_read   => MemRead_TL,
      write_data => RegBOut,
      mem_data   => MemDataOut
    );

  -- Memory Data Register
  MEM_DATA_REG : entity work.MemoryDataRegister(Behavioral)
    generic map ( DATA_WIDTH => 32 )
    port map (
      clk       => CLK,
      rst       => rst,
      mdr_write => MDRWrite_TL,
      mem_data  => MemDataOut,
      mdr_out   => MemoryDataRegOut
    );

  -- Mux 1: Selects between PC and ALU output for memory address
  MUX_1 : entity work.Mux2(Behavioral)
    generic map ( n => 32 )
    port map (
      input_1 => PC_out,
      input_2 => AluOutToMux,
      sel     => IorD_TL,
      output  => MuxToAddress
    );

  -- Mux 2: Selects destination register
  MUX_2 : entity work.Mux2_5(Behavioral)
    generic map ( n => 5 )
    port map (
      input_1 => InstructionRegOut(20 downto 16),
      input_2 => InstructionRegOut(15 downto 11),
      sel     => RegDst_TL,
      output  => MuxToWriteRegister
    );

  -- Mux 3: Selects between ALU output and MDR for write data
  MUX_3 : entity work.Mux2(Behavioral)
    generic map ( n => 32 )
    port map (
      input_1 => AluOutToMux,
      input_2 => MemoryDataRegOut,
      sel     => MemToReg_TL,
      output  => MuxToWriteData
    );

  -- Mux 4: Selects ALU operand A
  MUX_4 : entity work.Mux2(Behavioral)
    generic map ( n => 32 )
    port map (
      input_1 => PC_out,
      input_2 => RegAToMux,
      sel     => ALUSrcA_TL,
      output  => MuxToAlu
    );

  -- Mux 5: Selects ALU operand B
  MUX_5 : entity work.Mux4(Behavioral)
    generic map ( n => 32 )
    port map (
      input_1 => RegBOut,
      input_2 => PC_increment,
      input_3 => SignExtendOut,
      input_4 => ShiftLeft1ToMux4,
      sel     => ALUSrcB_TL,
      output  => Mux4ToAlu
    );

  -- Mux 6: Selects PC source
  MUX_6 : entity work.Mux3(Behavioral)
    generic map ( n => 32 )
    port map (
      input_1 => AluResultOut,
      input_2 => AluOutToMux,
      input_3 => full_jump_address,
      sel     => PCsource_TL,
      output  => MuxToPC
    );

  -- Program Counter
  PC : entity work.ProgramCounter(Behavioral)
    generic map ( ADDR_WIDTH => 32 )
    port map (
      clk       => CLK,
      rst       => rst,
      pc_in     => MuxToPC,
      pc_write  => ORtoPC,
      pc_out    => PC_out
    );

  -- Register File
  REG : entity work.Registers(Behavioral)
    generic map (
      ADDR_WIDTH => 5,
      DATA_WIDTH => 32,
      REG_COUNT  => 32
    )
    port map (
      clk          => CLK,
      rst          => rst,
      address_in_1 => InstructionRegOut(25 downto 21),
      address_in_2 => InstructionRegOut(20 downto 16),
      write_reg    => MuxToWriteRegister,
      write_data   => MuxToWriteData,
      reg_write    => RegWrite_TL,
      register_1   => ReadData1ToA,
      register_2   => ReadData2ToB
    );

  -- Sign Extend
  SE : entity work.SignExtend(Behavioral)
    generic map (
      input_width  => 16,
      output_width => 32
    )
    port map (
      input  => InstructionRegOut(15 downto 0),
      output => SignExtendOut
    );

  -- Shift Left 1: For branch address calculation
  SLL1 : entity work.ShiftLeft(Behavioral)
    generic map ( n => 32 )
    port map (
      input  => SignExtendOut,
      output => ShiftLeft1ToMux4
    );

  -- Shift Left 2: For jump address
  SLL2 : entity work.ShiftLeft2(Behavioral)
    generic map (
      input_width  => 26,
      output_width => 28
    )
    port map (
      input  => InstructionRegOut(25 downto 0),
      output => JumpAddress(27 downto 0)
    );

  -- Temporary Registers
  TEMP_REG : entity work.TempRegisters(Behavioral)
    generic map ( DATA_WIDTH => 32 )
    port map (
      clk         => CLK,
      rst         => rst,
      enable      => '1', -- Assuming always enabled; adjust if needed
      in_reg_a    => ReadData1ToA,
      in_reg_b    => ReadData2ToB,
      in_alu_out  => AluResultOut,
      out_reg_a   => RegAToMux,
      out_reg_b   => RegBOut,
      out_alu_out => AluOutToMux
    );

end Behavioral;