library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Parallel2Serial is
    port(
        nrst,sclk : in std_logic;    
        inbits : in std_logic_vector(1 downto 0);   
        outbit : out std_logic
    );
end  Parallel2Serial;

architecture arch of Parallel2Serial is 
   
    signal sel : std_logic;


begin
   
    process(nrst, sclk)
    begin
        if nrst = '0' then
            sel <= '0';
            outbit <= '0';
        elsif sclk'event and sclk = '1' then
            sel <= sel xor '1';
            if sel = '1' then
                outbit <= inbits(1);
            else
                outbit <= inbits(0);
            end if;    
        end if;

    end process;   


end arch;
