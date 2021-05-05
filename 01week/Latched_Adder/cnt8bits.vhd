library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cnt8bits is
    port(
        nrst,clk : in std_logic;        
        cntout : out std_logic_vector(7 downto 0)
    );
end cnt8bits;

architecture behavior of cnt8bits is 

    signal cnt : std_logic_vector(7 downto 0);

begin
    
    process(nrst, clk)
    begin
        if nrst = '0' then
            cnt <= (others => '0');
        elsif clk = '1' and clk'event then
            cnt <= cnt +'1';
        end if;
    end process;

    cntout <= cnt;

end behavior;

