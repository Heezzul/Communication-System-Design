library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library work;
use work.NCO_ROM_package.all;

entity NCOtable is
    port(
        nrst,clk : in std_logic;
        Address : in std_logic_vector(7 downto 0);
        NCO_I, NCO_Q : out std_logic_vector(9 downto 0)
    );
end NCOtable;

architecture beh of NCOtable is
    signal sdata,cdata : std_logic_vector(9 downto 0);
begin

    sdata <= SINROM_TABLE(Conv_Integer(unsigned(Address)));
    cdata <= COSROM_TABLE(Conv_Integer(unsigned(Address)));

    process(nrst, clk)
    begin     
        if nrst = '0' then
            NCO_I <= (others => '0');
            NCO_Q <= (others => '0');
        elsif clk = '1' and clk'event then
            NCO_I <= cdata;
            NCO_Q <= sdata;
        end if;
    end process;    

    


end beh;
