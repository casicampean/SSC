----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2019 10:28:23 PM
-- Design Name: 
-- Module Name: RAM - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM is
    Port(A, B, D: in STD_LOGIC_VECTOR(3 downto 0);
         clk, WE: in STD_LOGIC;
         AOut, BOut:out STD_LOGIC_VECTOR(3 downto 0));
end RAM;

architecture Behavioral of RAM is

type type_mem is array(15 downto 0) of STD_LOGIC_VECTOR(3 downto 0);
signal ram: type_mem := (
0 => "0000",
1 => "0001",
2 => "0010",
3 => "0011",
4 => "0100",
5 => "0101",
6 => "0110",
7 => "0111",
8 => "1000",
9 => "1001",
10 => "1010",
11 => "1011",
12 => "1100",
13 => "1101",
14 => "1110",
15 => "1111",
others => "0000");
begin
process(WE, D, B, clk)
    begin
        if clk ='0' and clk'event then
            if WE = '1' then
                ram(conv_integer(B)) <= D;
            end if;
        end if;
    end process;

AOut <= ram(conv_integer(A));
BOut <= ram(conv_integer(B));

end Behavioral;
