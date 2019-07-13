----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/22/2019 10:26:16 PM
-- Design Name: 
-- Module Name: QRegister - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity QRegister is
    Port(D: in STD_LOGIC_VECTOR(3 downto 0);
         clk, QEn:in STD_LOGIC;
         Q: out STD_LOGIC_VECTOR(3 downto 0));
end QRegister;

architecture Behavioral of QRegister is

begin

process(clk, QEn, D)
begin
    if rising_edge(clk) then
        if QEn = '1' then
            Q <= D;
        end if;
    end if;
end process;

end Behavioral;
