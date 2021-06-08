LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;


entity QPSK_LoopFilter is
    port(
        nrst : in std_logic;
        clk : in std_logic;
        Perr : in std_logic_vector(9 downto 0);

        LFout : out std_logic_vector(25 downto 0)
    );
end QPSK_LoopFilter;

architecture behavior of QPSK_LoopFilter is

    signal K1Perr : std_logic_vector(17 downto 0);
    signal Acc : std_logic_vector(25 downto 0);

    begin
        K1Perr <= sxt(Perr, 18);

        process(nrst, clk)
        begin
            if(nrst = '0') then
                Acc <= (others => '0');
            elsif clk = '1' and clk'event then
                Acc <= Acc + Perr;
            end if;
        end process;

        Lfout <= K1Perr & "00000000" +Acc;
         
        
end behavior;