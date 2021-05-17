library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library work;
use work.NCO_ROM_package.all;

entity NCO is
    port(
        nrst,clk : in std_logic;
        addr : in std_logic_vector(7 downto 0);
        NCO_R, NCO_I : out std_logic_vector(9 downto 0)
    );
end NCO;

architecture beh of NCO is
    signal sdata,cdata : std_logic_vector(9 downto 0);
begin

    sdata <= SINROM_TABLE(Conv_Integer(unsigned(addr)));
    cdata <= COSROM_TABLE(Conv_Integer(unsigned(addr)));

    process(nrst, clk)
    begin     
        if nrst = '0' then
            NCO_R <= (others => '0');
            NCO_I <= (others => '0');
        elsif clk = '1' and clk'event then
            NCO_R <= cdata;
            NCO_I <= sdata;
        end if;
    end process;    

    


end beh;
