----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2019 04:52:44 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port(R, S: in STD_LOGIC_VECTOR(3 downto 0);
         Operation:in STD_LOGIC_VECTOR(2 downto 0);
         CIn: in STD_LOGIC;
         COut: out STD_LOGIC;
		 OVR: out STD_LOGIC;
		 F3: out STD_LOGIC;
		 Zero: out STD_LOGIC;
		 G: out STD_LOGIC;
		 P: out STD_LOGIC;
         F: out STD_LOGIC_VECTOR(3 downto 0));      
end ALU;

architecture Behavioral of ALU is

signal R_aux,S_aux,F_aux: STD_LOGIC_VECTOR(4 downto 0);
signal P0, P1, P2, P3: STD_LOGIC;
signal G0, G1, G2, G3: STD_LOGIC;
signal C4, C3: STD_LOGIC;


begin

R_aux <= '0' & R;
S_aux <= '0' & S;

process(Operation, R_aux, S_aux, CIn)
begin 
    case Operation is

    when "000" => --add
            P0 <= R(0) or S(0);
            P1 <= R(1) or S(1);
            P2 <= R(2) or S(2);
            P3 <= R(3) or S(3);

            G0 <= R(0) and S(0);
            G1 <= R(1) and S(1);
            G2 <= R(2) and S(2);
            G3 <= R(3) and S(3);

            C4 <= G3 or (P3  and G2) or (P2 and (P1 and G0)) or
                ((P3 and P2) and (P1 and G0)) or ((P3 and P2) and (P1 and CIn));
            C3 <= G2 or (P2 and G1) or (P2 and (P1 and G0)) 
                or ((P2 and P1) and (P0 and CIn));
			if CIn = '1' then
				F_aux <= R_aux + S_aux + 1;
			else
				F_aux <= R_aux + S_aux;
			end if;
			P <= not((P3 and P2) and (P1 and P0));
			G <= not(G3 or (P3 and G2) or (P3 and (P2 and G1)) or 
			     ((P3 and P2) and (P1 and G0)));
		    COut <= G3 or (P3  and G2) or (P2 and (P1 and G0)) or
                ((P3 and P2) and (P1 and G0)) or ((P3 and P2) and (P1 and CIn));
			OVR <= (G2 or (P2 and G1) or (P2 and (P1 and G0)) 
                or ((P2 and P1) and (P0 and CIn))) xor (G3 or (P3  and G2) or (P2 and (P1 and G0)) or
                ((P3 and P2) and (P1 and G0)) or ((P3 and P2) and (P1 and CIn)));
			
    when "001" => --subr
            P0 <= not(R(0)) or S(0);
            P1 <= not(R(1)) or S(1);
            P2 <= not(R(2)) or S(2);
            P3 <= not(R(3)) or S(3);

            G0 <= not(R(0)) and S(0);
            G1 <= not(R(1)) and S(1);
            G2 <= not(R(2)) and S(2);
            G3 <= not(R(3)) and S(3);

            C4 <= G3 or (P3  and G2) or (P2 and (P1 and G0)) or
              ((P3 and P2) and (P1 and G0)) or ((P3 and P2) and (P1 and CIn));
            C3 <= G2 or (P2 and G1) or (P2 and (P1 and G0)) 
              or ((P2 and P1) and (P0 and CIn));
	  
			if CIn = '0' then
				F_aux <= S_aux + not(R_aux) + 1;
			else
				F_aux <= S_aux + not(R_aux) + 2;
			end if;
			
			P <= not((P3 and P2) and (P1 and P0));
			G <= not(G3 or (P3 and G2) or (P3 and (P2 and G1)) or 
			     ((P3 and P2) and (P1 and G0)));
		    COut <= G3 or (P3  and G2) or (P2 and (P1 and G0)) or
                ((P3 and P2) and (P1 and G0)) or ((P3 and P2) and (P1 and CIn));
			OVR <= (G2 or (P2 and G1) or (P2 and (P1 and G0)) 
                or ((P2 and P1) and (P0 and CIn))) xor (G3 or (P3  and G2) or (P2 and (P1 and G0)) or
                ((P3 and P2) and (P1 and G0)) or ((P3 and P2) and (P1 and CIn)));
				
    when "010" => --subs
	
            P0 <= R(0) or not(S(0));
            P1 <= R(1) or not(S(1));
            P2 <= R(2) or not(S(2));
            P3 <= R(3) or not(S(3));

            G0 <= R(0) and not(S(0));
            G1 <= R(1) and not(S(1));
            G2 <= R(2) and not(S(2));
            G3 <= R(3) and not(S(3));

            C4 <= G3 or (P3  and G2) or (P2 and (P1 and G0)) or
              ((P3 and P2) and (P1 and G0)) or ((P3 and P2) and (P1 and CIn));
            C3 <= G2 or (P2 and G1) or (P2 and (P1 and G0)) 
              or ((P2 and P1) and (P0 and CIn));
	
			if CIn = '0' then
				F_aux <= R_aux + not(S_aux) + 1;
			else
				F_aux <= R_aux + not(S_aux) + 2;
			end if;
			
			P <= not((P3 and P2) and (P1 and P0));
			G <= not(G3 or (P3 and G2) or (P3 and (P2 and G1)) or 
			     ((P3 and P2) and (P1 and G0)));
		    COut <= G3 or (P3  and G2) or (P2 and (P1 and G0)) or
                ((P3 and P2) and (P1 and G0)) or ((P3 and P2) and (P1 and CIn));
			OVR <= (G2 or (P2 and G1) or (P2 and (P1 and G0)) 
                or ((P2 and P1) and (P0 and CIn))) xor (G3 or (P3  and G2) or (P2 and (P1 and G0)) or
                ((P3 and P2) and (P1 and G0)) or ((P3 and P2) and (P1 and CIn)));
				
    when "011" => F_aux <= R_aux or S_aux;  --or
            P0 <= R(0) or S(0);
            P1 <= R(1) or S(1);
            P2 <= R(2) or S(2);
            P3 <= R(3) or S(3);

            G0 <= R(0) and S(0);
            G1 <= R(1) and S(1);
            G2 <= R(2) and S(2);
            G3 <= R(3) and S(3);

            C4 <= G3 or (P3  and G2) or (P2 and (P1 and G0)) or
                  ((P3 and P2) and (P1 and G0)) or ((P3 and P2) and (P1 and CIn));
            C3 <= G2 or (P2 and G1) or (P2 and (P1 and G0)) 
                  or ((P2 and P1) and (P0 and CIn));
            P <= '0'; 
            G <= ((P3 and P2)  and (P1 and P0));
            OVR <= not((P3 and P2)  and (P1 and P0)) or CIn;
            COut <= not((P3 and P2)  and (P1 and P0)) or CIn;

				  
    when "100" => F_aux <= R_aux and S_aux; --and
            P0 <= R(0) or S(0);
            P1 <= R(1) or S(1);
            P2 <= R(2) or S(2);
            P3 <= R(3) or S(3);

            G0 <= R(0) and S(0);
            G1 <= R(1) and S(1);
            G2 <= R(2) and S(2);
            G3 <= R(3) and S(3);

            C4 <= G3 or (P3  and G2) or (P2 and (P1 and G0)) or
                  ((P3 and P2) and (P1 and G0)) or ((P3 and P2) and (P1 and CIn));
            C3 <= G2 or (P2 and G1) or (P2 and (P1 and G0)) 
                  or ((P2 and P1) and (P0 and CIn));
            P <= '0';
            G <= not((G3 or G2) or (G1 or G0));
            COut <= G3 or G2 or G1 or G0 or CIn;
            OVR <= G3 or G2 or G1 or G0 or CIn;
				  
    when "101" => F_aux <= not(R_aux) and S_aux; --notrs
			P0 <= not(R(0)) or S(0);
			P1 <= not(R(1)) or S(1);
			P2 <= not(R(2)) or S(2);
			P3 <= not(R(3)) or S(3);

			G0 <= not(R(0)) and S(0);
			G1 <= not(R(1)) and S(1);
			G2 <= not(R(2)) and S(2);
			G3 <= not(R(3)) and S(3);

			C4 <= G3 or (P3  and G2) or (P2 and (P1 and G0)) or
				((P3 and P2) and (P1 and G0)) or ((P3 and P2) and (P1 and CIn));
			C3 <= G2 or (P2 and G1) or (P2 and (P1 and G0)) 
				or ((P2 and P1) and (P0 and CIn));
	  
			P <= '0';
			G <= not((G3 or G2) or (G1 or G0));
			COut <= G3 or G2 or G1 or G0 or CIn;
			OVR <= G3 or G2 or G1 or G0 or CIn;
			
    when "110" => F_aux <= R_aux xor S_aux; --exor
			P0 <= not(R(0)) or S(0);
			P1 <= not(R(1)) or S(1);
			P2 <= not(R(2)) or S(2);
			P3 <= not(R(3)) or S(3);

			G0 <= not(R(0)) and S(0);
			G1 <= not(R(1)) and S(1);
			G2 <= not(R(2)) and S(2);
			G3 <= not(R(3)) and S(3);

			C4 <= G3 or (P3  and G2) or (P2 and (P1 and G0)) or
				((P3 and P2) and (P1 and G0)) or ((P3 and P2) and (P1 and CIn));
			C3 <= G2 or (P2 and G1) or (P2 and (P1 and G0)) 
				or ((P2 and P1) and (P0 and CIn));
			P <= ((G3 or G2) or (G1 or G0));
			G <= (G3 or (P3  and G2) or (P2 and (P1 and G0)) or
				((P3 and P2) and (P1 and G0)) or ((P3 and P2)));
			COut <= not(G3 or (P3 or P2) or (P3 and (P2 and P1)) or
				(((P3 and P2) and (P1 and P0)) and (G0 or not(CIn))));
			OVR <= ( not(P2) or (not(G2) and not(P1)) or (not(G2) and (not(G1) and not(G0)))
				or ((not(G2) and not(G1)) and (not(G0) and CIn))) xor
				( not(P3) or (not(G3) and not(P2)) or ((not(G3) and not(G2)) and (not(G1) and (not(G0)))) or
				((not(G3)  and not(G2)) and (not(G1) and not(G0)) and CIn));
				
    when "111" => F_aux <= not(R_aux xor S_aux); --exnor
            P0 <= R(0) or S(0);
            P1 <= R(1) or S(1);
            P2 <= R(2) or S(2);
            P3 <= R(3) or S(3);

            G0 <= R(0) and S(0);
            G1 <= R(1) and S(1);
            G2 <= R(2) and S(2);
            G3 <= R(3) and S(3);

            C4 <= G3 or (P3  and G2) or (P2 and (P1 and G0)) or
                  ((P3 and P2) and (P1 and G0)) or ((P3 and P2) and (P1 and CIn));
            C3 <= G2 or (P2 and G1) or (P2 and (P1 and G0)) 
                  or ((P2 and P1) and (P0 and CIn));
			P <= ((G3 or G2) or (G1 or G0));
			G <= (G3 or (P3  and G2) or (P2 and (P1 and G0)) or
				 ((P3 and P2) and (P1 and G0)) or ((P3 and P2)));
			COut <= not(G3 or (P3 or P2) or (P3 and (P2 and P1)) or
				  (((P3 and P2) and (P1 and P0)) and (G0 or not(CIn))));
			OVR <= ( not(P2) or (not(G2) and not(P1)) or (not(G2) and (not(G1) and not(G0)))
					or ((not(G2) and not(G1)) and (not(G0) and CIn))) xor
					( not(P3) or (not(G3) and not(P2)) or ((not(G3) and not(G2)) and (not(G1) and (not(G0)))) or
					((not(G3)  and not(G2)) and (not(G1) and not(G0)) and CIn));
    when others => F_aux <= "00000";
    end case;
end process;


F <= F_aux(3 downto 0);
F3 <= F_aux(3);
Zero <= '1' when F_aux = "00000" else '0';

    


end Behavioral;
