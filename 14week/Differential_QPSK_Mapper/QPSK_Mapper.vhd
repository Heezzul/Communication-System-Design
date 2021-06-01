library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity QPSKmapper is
    port(
        nrst,pclk: in std_logic;    
        inbits : in std_logic_vector(1 downto 0);

        rdata : out std_logic_vector(5 downto 0);
        idata : out std_logic_vector(5 downto 0)
    );
end  QPSKmapper;

architecture arch of QPSKmapper is 
   
    constant pvalue : std_logic_vector(5 downto 0) := "010000";
    constant mvalue : std_logic_vector(5 downto 0) := "110000";


begin
   
    process(nrst, pclk)
    begin
        if nrst = '0' then
            rdata <= (others => '0');
            idata <= (others => '0');
        elsif pclk'event and pclk = '1' then
          --  if inbits(1) = '0' and inbits(0) = '0' then
            if inbits = "00" then        
                rdata <= pvalue; 
                idata <= pvalue;
            --elsif inbits(1) = '0' and inbits(0) = '1' then
            elsif inbits = "01" then
                rdata <= pvalue; 
                idata <= mvalue;
           -- elsif inbits(1) = '1' and inbits(0) = '0' then
            elsif inbits = "10" then    
                rdata <= mvalue; 
                idata <= pvalue;
            --elsif inbits(1) = '1' and inbits(0) = '1' then
            elsif inbits = "11" then
                rdata <= mvalue; 
                idata <= mvalue;         
            end if;          
        end if;

    end process;   


end arch;
