library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Serial2Parallel is
    port(
        nrst,sclk,pclk : in std_logic;    
        inbit : in std_logic;   
        outbits : out std_logic_vector(1 downto 0)
    );
end  Serial2Parallel;

architecture arch of Serial2Parallel is 
   
    signal inbuf : std_logic;


begin
   
    process(nrst, sclk)
    begin
        if nrst = '0' then
            inbuf <= '0';
        elsif sclk'event and sclk = '1' then
            inbuf <= inbit;
        end if;

    end process;

    process(nrst, pclk)
    begin
        if nrst = '0' then
            outbits <= (others => '0');
        elsif pclk'event and pclk = '1' then
            outbits <= inbuf & inbit;
        end if;

    end process;

    


end arch;
