library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is
    port(
        nrst,clk : in std_logic;      
        direction : in std_logic;  
        cntout : out std_logic_vector(4 downto 0)
    );
end  counter;

architecture behavior of  counter is 

    signal cnt : std_logic_vector(4 downto 0);

begin
    
    process(nrst, clk, direction)
    begin
        if nrst = '0' then
            cnt <= (others => '0');
        elsif clk = '1' and clk'event and direction = '0' then
            cnt <= cnt +'1';
        elsif clk = '1' and clk'event and direction = '1' then
            cnt <= cnt -'1';
        end if;
    end process;

    cntout <= cnt;

end behavior;

