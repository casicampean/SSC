----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2019 03:39:47 PM
-- Design Name: 
-- Module Name: MicroInstructions - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MicroInstructions is
    Port( clk, buton, rst:in STD_LOGIC;
    cnt: out STD_LOGIC_VECTOR(15 downto 0);
         Instr: out STD_LOGIC_VECTOR(8 downto 0));
end MicroInstructions;

architecture Behavioral of MicroInstructions is
 
type program_type is array(0 to 255) of STD_LOGIC_VECTOR(8 downto 0);
signal program: program_type:=(
0=>B"001_000_001",--NOP_ADD_AB A=2, B=8, Y=10

1=>B"000_001_011", --QREG_SUBR_ZB B=5, F=5, Q=5, Y=5

2=>B"011_100_100", --RAMF_AND_ZA A=4 F=0 B=3 RAM(3)=0 Y=0

3=>B"011_011_010", --RAMF_OR_ZQ Q=5 F=5 B=10 RAM(10)=5 A=3 Y=5

4=>B"100_010_101", --RAMQD_SUBS_DA D=9 A=5 F=4 Y=4 B=4, RAM(4)=5/2=2 Q=Q/2=2
	
5=>B"101_000_101", --RAMD_ADD_DA D=6 A=15 F=5 Y=5 B=6 RAM(6)=5/2=2

6=>B"001_101_110",--NOP_NOTRS_DQ d=8 Q=2 Y=2 

7=>B"110_110_111", --RAMQU_EXOR_DZ D=2 F=2 Y=2 B=15 RAM(15)=2*2=4 Q=2*2=4

8=>B"111_111_000", --RAMU_EXNOR_AQ A=15 Q=4 F=4 Y=4 B=7 RAM(7)=4*2=8

9=>B"010_000_110",--RAMA_ADD_DQ Q=4 D=10 Q=4 CARRY=1 Y=15 B=6 RAM(6)=15 

10=>B"100_011_111",--RAMQD_OR_DZ D=4 Y=4 RAM3=Q3=1 B=7 RAM(7)=10 Q=10 

11=>B"101_001_000",--RAMD_SUBR_AQ A=7(10) Q=10 CARRY=1 Y=1 B=15 RAM(15)=8

12=>B"110_011_100",--RAMQU__OR_ZA A=10 Y=10 B=14 RAM(14)=5 Q=5

13=>B"111_010_100",--RAMU_SUBS_ZA A=14(5) Y=12 B=15 RAM(15)=9



14=>B"000_000_000",	
15=>B"000_000_000",	
16=>B"000_000_000",	
17=>B"000_000_000",	
18=>B"000_000_000",	
19=>B"000_000_000",	
20=>B"000_000_000",	

others=>"000000000");

signal count:STD_LOGIC_VECTOR(15 downto 0):=x"0000";

begin
process(buton, clk)
begin
    if rising_edge(clk) then
      if buton='1' then
           count<=count+1;          
      end if;
          if rst = '1' then
        count<= x"0000";
    end if;
    end if;
  end process;
  
Instr<=program(conv_integer(count));
cnt<=count;
end Behavioral;
