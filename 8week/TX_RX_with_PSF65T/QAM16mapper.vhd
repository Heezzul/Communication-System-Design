library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity QAM16mapper is
    port(
        nrst,pclk: in std_logic;    
        inbits : in std_logic_vector(3 downto 0);

        rdata : out std_logic_vector(5 downto 0);
        idata : out std_logic_vector(5 downto 0)
    );
end  QAM16mapper;

architecture arch of QAM16mapper is 
   
    constant pvalue : std_logic_vector(5 downto 0) := "001000";
    constant pvalue2 : std_logic_vector(5 downto 0) := "011000";
    constant mvalue : std_logic_vector(5 downto 0) := "101000";
    constant mvalue2 : std_logic_vector(5 downto 0) := "111000";


begin
   
    process(nrst, pclk)
    begin
        if nrst = '0' then
            rdata <= (others => '0');
            idata <= (others => '0');
        elsif pclk'event and pclk = '1' then
            if inbits = "0000" then        
                rdata <= pvalue2; 
                idata <= pvalue2;
            elsif inbits = "0001" then
                rdata <= pvalue2; 
                idata <= pvalue;
            elsif inbits = "0010" then    
                rdata <= pvalue; 
                idata <= pvalue2;
            elsif inbits = "0011" then
                rdata <= pvalue; 
                idata <= pvalue;         
            elsif inbits = "0100" then        
                rdata <= pvalue2; 
                idata <= mvalue2;
            elsif inbits = "0101" then
                rdata <= pvalue2; 
                idata <= mvalue;
            elsif inbits = "0110" then    
                rdata <= pvalue; 
                idata <= mvalue2;
            elsif inbits = "0111" then
                rdata <= pvalue; 
                idata <= mvalue;
            elsif inbits = "1000" then        
                rdata <= mvalue2; 
                idata <= pvalue2;
            elsif inbits = "1001" then
                rdata <= mvalue2; 
                idata <= pvalue;
            elsif inbits = "1010" then    
                rdata <= mvalue; 
                idata <= pvalue2;
            elsif inbits = "1011" then
                rdata <= mvalue; 
                idata <= pvalue;
            elsif inbits = "1100" then        
                rdata <= mvalue2; 
                idata <= mvalue2;
            elsif inbits = "1101" then
                rdata <= mvalue2; 
                idata <= mvalue;
            elsif inbits = "1110" then    
                rdata <= mvalue; 
                idata <= mvalue2;
            elsif inbits = "1111" then
                rdata <= mvalue; 
                idata <= mvalue;                       
            
            end if;          
        end if;

    end process;   


end arch;
