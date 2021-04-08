library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity QPSKdemapper is
    port(
        nrst,pclk: in std_logic;
        rdata : in std_logic_vector(5 downto 0);
        idata : in std_logic_vector(5 downto 0);

        outbits : out std_logic_vector(1 downto 0)
    );
end  QPSKdemapper;

architecture arch of QPSKdemapper is    
   
begin
   
    process(nrst, pclk)
    begin
        if nrst = '0' then
            outbits <= (others => '0');            
        elsif pclk'event and pclk = '1' then
            if rdata(5) = '0' and idata(5) = '0' then
                outbits <= "00";
            elsif rdata(5) = '0' and idata(5) = '1' then
                outbits <= "01";        
            elsif rdata(5) = '1' and idata(5) = '0' then
                outbits <= "10"; 
            elsif rdata(5) = '1' and idata(5) = '1' then
                outbits <= "11";                  
            end if;
        end if;

    end process;   


end arch;
