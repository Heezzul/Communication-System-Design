library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity QAM16demapper is
    port(
        nrst,pclk: in std_logic;
        rdata : in std_logic_vector(5 downto 0);
        idata : in std_logic_vector(5 downto 0);

        outbits : out std_logic_vector(3 downto 0)
    );
end  QAM16demapper;

architecture arch of QAM16demapper is    
   
begin
   
    process(nrst, pclk)
    begin
        if nrst = '0' then
            outbits <= (others => '0');            
        elsif pclk'event and pclk = '1' then
            if rdata(5 downto 4) = "01" and idata(5 downto 4) = "01"   then
                outbits <= "0000";
            elsif rdata(5 downto 4) = "01" and idata(5 downto 4) = "00"  then
                outbits <= "0001";        
            elsif rdata(5 downto 4) = "00" and idata(5 downto 4) = "01"  then
                outbits <= "0010"; 
            elsif rdata(5 downto 4) = "00" and idata(5 downto 4) = "00"  then
                outbits <= "0011";   
            elsif rdata(5 downto 4) = "01" and idata(5 downto 4) = "11"   then
                outbits <= "0100";
            elsif rdata(5 downto 4) = "01" and idata(5 downto 4) = "10"  then
                outbits <= "0101";        
            elsif rdata(5 downto 4) = "00" and idata(5 downto 4) = "11"  then
                outbits <= "0110"; 
            elsif rdata(5 downto 4) = "00" and idata(5 downto 4) = "10"  then
                outbits <= "0111";    
            elsif rdata(5 downto 4) = "11" and idata(5 downto 4) = "01"   then
                outbits <= "1000";
            elsif rdata(5 downto 4) = "11" and idata(5 downto 4) = "00"  then
                outbits <= "1001";        
            elsif rdata(5 downto 4) = "10" and idata(5 downto 4) = "01"  then
                outbits <= "1010"; 
            elsif rdata(5 downto 4) = "10" and idata(5 downto 4) = "00"  then
                outbits <= "1011";       
            elsif rdata(5 downto 4) = "11" and idata(5 downto 4) = "11"   then
                outbits <= "1100";
            elsif rdata(5 downto 4) = "11" and idata(5 downto 4) = "10"  then
                outbits <= "1101";        
            elsif rdata(5 downto 4) = "10" and idata(5 downto 4) = "11"  then
                outbits <= "1110"; 
            elsif rdata(5 downto 4) = "10" and idata(5 downto 4) = "10"  then
                outbits <= "1111";                       
            end if;
        end if;

    end process;   


end arch;
