library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Parallel2Serial is
    generic (prate : in integer);
    port(
        nrst,sclk : in std_logic;    
        inbits : in std_logic_vector((prate -1) downto 0);   
        outbit : out std_logic
    );
end  Parallel2Serial;

architecture arch of Parallel2Serial is 
   
    signal state : integer range 0 to (prate-1);


begin
   
    process(nrst, sclk)
    begin
        if nrst = '0' then
           state <= (prate/2);
        
        elsif sclk'event and sclk = '1' then
            if (state = prate-1) then
                state <= 0;
            else
                state <= state  +1;
            end if;    
        end if;

    end process;   

    process(nrst, sclk)
    begin
        if nrst = '0' then
            outbit <= '0';
            elsif sclk'event and sclk = '1' then
                outbit <= inbits((prate-1)-state);
            end if;
        end process;


end arch;
