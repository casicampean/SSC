----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/23/2019 06:35:40 PM
-- Design Name: 
-- Module Name: AMD - Behavioral
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

entity AMD is
    Port(Clk, Rst: in STD_LOGIC;
         Btn, BtnUp: in STD_LOGIC;
         --A, B, D:in STD_LOGIC_VECTOR(3 downto 0);
         sw : in STD_LOGIC_VECTOR (15 downto 0);
         led : out STD_LOGIC_VECTOR (15 downto 0);
         --an : out STD_LOGIC_VECTOR (3 downto 0);
         an, cat : out STD_LOGIC_VECTOR (7 downto 0)
         --CIn, RAM0, RAM3,Q0, Q3 : in STD_LOGIC;
         --cat : out STD_LOGIC_VECTOR (6 downto 0)
);
end AMD;

architecture Behavioral of AMD is

signal Instr: STD_LOGIC_VECTOR(8 downto 0);
signal cnt: STD_LOGIC_VECTOR(15 downto 0);
signal Func,Op, Dest: STD_LOGIC_VECTOR(2 downto 0);
signal A, B, D: STD_LOGIC_VECTOR(3 downto 0):="0000";
signal  Q, R, S, F, ShiftQ, ShiftF, AOut, BOut, ALatch, BLatch, Y: STD_LOGIC_VECTOR(3 downto 0):="0000";
signal Z: STD_LOGIC_VECTOR(3 downto 0):="0000";
--signal dig: STD_LOGIC_VECTOR(15 downto 0);
signal dig: STD_LOGIC_VECTOR(31 downto 0);
signal ShiftRAMDown,ShiftRAMUp, ShiftQDown,ShiftQUp, QEn, EnRAM, AorF, butonMPGOut: STD_LOGIC:='0';
signal COut, OVR, F3, Zero, G, P,  rstInstr:  STD_LOGIC:='0';
signal RAM0, RAM3, Q0, Q3, CIn:STD_LOGIC:='0';

begin

---OP:I2_I1_I0 R S
---000 AQ
---001 AB
---010 ZQ (Z=0)
---011 ZB
---100 ZA
---101 DA
---110 DQ
---111 DZ

---FUNC:I5_I4_I3
---000 ADD R+S
---001 SUBR S-R
---010 SUBS R-S
---011 OR
---100 AND
---101 NOTRS NOT(R) AND S
---110 EXOR
---111 EXNOR NOT(R XOR S)

---Dest I8_I7_I6
---000 QREG
---001 NOP
---010 RAMA
---011 RAMF
---100 RAMQD
---101 RAMD
---110 RAMQU
---111 RAMU

    
A <= sw(3 downto 0);
B <= sw(7 downto 4);
D <= sw(11 downto 8);
CIn <=sw(12);
RAM0<=sw(12);
RAM3<=sw(13);
Q0<=sw(14);
Q3<=sw(15);

Op <= Instr(2 downto 0);
Func <= Instr(5 downto 3);
Dest <= Instr(8 downto 6);

Y <= ALatch when AorF = '1' else F;

source_operands:process(Op, ALatch, BLatch, Q, D, Instr,Z)
begin
    case Op is
        when "000" => R <= ALatch; S <= Q;
        when "001" => R <= ALatch; S <= BLatch;
        when "010" => R <= Z; S <= Q;
        when "011" => R <= Z; S <= BLatch;
        when "100" => R <= Z; S <= ALatch;
        when "101" => R <= D; S <= ALatch;
        when "110" => R <= D; S <= Q;
        when "111" => R <= D; S <= Z;
        when others => R<="0000"; S<= "0000";
    end case;
end process;

alu_destination:process(Dest, Instr)
begin
    case Dest is
        --QREG
        when "000" => ShiftRAMDown<= '0'; ShiftRAMUp <= '0';ShiftQDown <= '0';ShiftQUp <= '0';
                      QEn <= '1'; AorF <= '0'; EnRAM <='0'; --RAM0 <= '0'; RAM3 <= '0'; Q0 <= '0'; Q3 <= '0';
        --NOP               
        when "001" => ShiftRAMDown<= '0'; ShiftRAMUp <= '0';ShiftQDown <= '0';ShiftQUp <= '0';
                      QEn <= '0'; AorF <= '0'; EnRAM <='0'; --RAM0 <= '0'; RAM3 <= '0'; Q0 <= '0'; Q3 <= '0';
        --RAMA              
        when "010" => ShiftRAMDown<= '0'; ShiftRAMUp <= '0';ShiftQDown <= '0';ShiftQUp <= '0';
                      QEn <= '0'; AorF <= '1'; EnRAM <='1';-- RAM0 <= '0'; RAM3 <= '0'; Q0 <= '0'; Q3 <= '0';
        --RAMB             
        when "011" => ShiftRAMDown<= '0'; ShiftRAMUp <= '0';ShiftQDown <= '0';ShiftQUp <= '0';
                      QEn <= '0'; AorF <= '0'; EnRAM <='1'; --RAM0 <= '0'; RAM3 <= '0'; Q0 <= '0'; Q3 <= '0';
        --RAMQD               
        when "100" => ShiftRAMDown<= '1'; ShiftRAMUp <= '0';ShiftQDown <= '1';ShiftQUp <= '0';
                      QEn <= '1'; AorF <= '0'; EnRAM <='1'; --RAM0 <= F(0); RAM3 <= '0'; Q0 <= Q(0); Q3 <= '0';
        --RAMD             
        when "101" => ShiftRAMDown<= '1'; ShiftRAMUp <= '0';ShiftQDown <= '0';ShiftQUp <= '0';
                      QEn <= '0'; AorF <= '0'; EnRAM <='1'; --RAM0 <= F(0); RAM3 <= '0'; Q0 <= Q(0); Q3 <= '0';
        --RAMQU              
        when "110" => ShiftRAMDown<= '0'; ShiftRAMUp <= '1';ShiftQDown <= '0';ShiftQUp <= '1';
                      QEn <= '1'; AorF <= '0'; EnRAM <='1'; --RAM0 <= '0'; RAM3 <= F(3); Q0 <= '0'; Q3 <= Q(3);
        --RAMU              
        when "111" => ShiftRAMDown<= '0'; ShiftRAMUp <= '1';ShiftQDown <= '0';ShiftQUp <= '0';
                      QEn <= '0'; AorF <= '0'; EnRAM <='1'; --RAM0 <= '0'; RAM3 <= F(3); Q0 <= '0'; Q3 <= Q(3);
        when others =>
    end case;
end process;


Shift_Q: process(ShiftQUp, ShiftQDown, QEn, Instr, clk, Q3, Q0, Q, F)
begin
    if ShiftQDown = '1' and ShiftQUp = '0' then
        ShiftQ <= Q3 & Q(3 downto 1);
    end if;
    if ShiftQUp = '1' and ShiftQDown = '0' then
        ShiftQ <= Q(2 downto 0) & Q0;
    end if;
    if ShiftQUp = '0' and ShiftQDown = '0' then
        ShiftQ <= F;
    end if;
end process;

Shift_F:process(ShiftRAMDown,ShiftRAMUp, EnRAM, Instr, clk)
begin
    if ShiftRAMDown = '1' and ShiftRAMUp = '0' then
        ShiftF <= RAM3 & F(3 downto 1);
    end if;
    if ShiftRAMDown = '0' and ShiftRAMUp = '1' then
        ShiftF <= F(2 downto 0) & RAM0;
    end if;
    if ShiftRAMDown = '0' and ShiftRAMUp = '0' then
        ShiftF <= F;
    end if;
end process;   

led(0)<=COut;
led(1)<=OVR;
led(2)<=F3;
led(3)<=Zero;
led(4)<=G;
led(5)<=P;

ALU_component: entity WORK.ALU port map (
    R => R,
    S => S,
    Operation => Func,
    CIn => CIn,
    COut => COut,
	OVR => OVR,
	F3 => F3,
	Zero => Zero,
	G => G,
	P => P,
    F => F
);

RAM_component: entity WORK.RAM port map (
    A => A, 
    B => B, 
    D => ShiftF,
    clk => Clk,
    WE => EnRAM,
    AOut => AOut,
    BOut => BOut
);

QRegister_component: entity WORK.QRegister port map (
    D => ShiftF,
    clk => Clk, 
    QEn => QEn,
    Q => Q
);

LatchA_component: entity WORK.Latch port map (
    clk => Clk,
    d => AOut,
    q => ALatch
);

LatchB_component: entity WORK.Latch port map (
    clk => Clk,
    d => BOut,
    q => BLatch
);

MicroInstructions_component: entity WORK.MicroInstructions port map (
    clk => Clk,
    buton => butonMPGOut,
    --buton => btn(0),
    rst => rstInstr,
    --rst => btn(1),
    cnt => cnt,
    Instr => Instr
);

MPG_component: entity WORK.MPG port map (

    en => butonMPGOut,
    input => Btn,
    clk => Clk
);

MPG_component2: entity WORK.MPG port map (

    en => rstInstr,
    input => BtnUp,
    clk => Clk
);

--dig<="000000000000"&Y;
dig<="0000000000000000000000000000"&Y;

--process(sw(14 downto 12),A,B,Instr,D, Q, Y, cnt)
--  begin
--     case sw(14 downto 12) is
--     when "000" => dig<="0000000"&Instr;
--     when "001" => dig<="000000000000"&A;
--     when "010" => dig<="000000000000"&B;
--     when "011" => dig<="000000000000"&D;
--     when "100" => dig<="000000000000"&Q;
--     when "101" => dig<="000000000000"&Y;
--     when "110" => dig<=cnt;
--     when others =>dig<=x"0000";
--    end case;
  
--  end process; 

--SSD_component: entity WORK.SSD port map ( 
--   clk => clk,
--    digit => dig,
--    an => an,
--    cat => cat
--);

display_component: entity WORK.displ7seg port map(
           Clk => Clk,
           Rst => Rst, 
           Data => dig,--: in  STD_LOGIC_VECTOR (31 downto 0);   -- datele pentru 8 cifre (cifra 1 din stanga: biti 31..28)
           An => an,  --: out STD_LOGIC_VECTOR (7 downto 0);    -- selectia anodului activ
           Seg => cat --: out STD_LOGIC_VECTOR (7 downto 0)); 
);

    

end Behavioral;
