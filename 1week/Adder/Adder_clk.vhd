library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Adder_clk is
    port(
        nrst,clk : in std_logic;
        InData : in std_logic_vector(7 downto 0);
        OutData : out std_logic_vector(7 downto 0)
    );
end  Adder_clk;

architecture arch of  Adder_clk is 

    signal a : std_logic_vector(7 downto 0);

begin
   
    process(nrst, clk)
    begin
        if nrst = '0' then
            a <= (others => '0');
            
        elsif clk = '1' and clk'event then
            a <= InData + "10";
        end if;

    end process;

    OutData <= a;


end arch;

