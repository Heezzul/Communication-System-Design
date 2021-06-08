library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

library work;
use work.mypackage.all;

entity QPSK_PED is 
port(
    nrst : in std_logic;
    clk : in std_logic;
    rin, iin : in std_logic_vector(9 downto 0);

    Perr : out std_logic_vector(9 downto 0)
);
end QPSK_PED;

architecture behavior of QPSK_PED is

signal Rsign, Isign : std_logic;

begin
    Rsign <= rin(9);
    Isign <= iin(9);

    process(nrst, clk)
    begin
        if nrst = '0' then
            Perr <= (others => '0');
        elsif clk = '1' and clk'event then
            if(Rsign = '0') then
                if(Isign = '0') then
                    Perr <= iin  - rin;
                else
                    Perr <= iin + rin;
                end if;
            else
                if( Isign = '0') then
                   Perr <= -iin - rin;
                else
                   Perr <= rin - iin;
                end if;
            end if;
        end if;
    end process;

end behavior;


    

