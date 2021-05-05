library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Serial2Parallel is
    generic (prate : in integer);
    port(
        nrst,sclk,pclk : in std_logic;    
        inbit : in std_logic;   
        outbits : out std_logic_vector((prate -1) downto 0)
    );
end  Serial2Parallel;

architecture arch of Serial2Parallel is 
   
    signal inbuf : std_logic_vector((prate -1) downto 0);


begin
   
    process(nrst, sclk)
    begin
        if nrst = '0' then
            inbuf <= (others => '0');
        elsif sclk'event and sclk = '1' then
            inbuf((prate-1) downto 1) <= inbuf((prate-2) downto 0);
            inbuf(0) <= inbit;
        end if;
    end process;

    process(nrst, pclk)
    begin
        if nrst = '0' then
            outbits <= (others => '0');
        elsif pclk'event and pclk = '1' then
            outbits <= inbuf;
        end if;

    end process;

    


end arch;
