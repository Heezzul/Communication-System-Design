library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Latched_Adder is
    port(
        nrst,clk : in std_logic;
        InData : in std_logic_vector(7 downto 0);
        OutData : out std_logic_vector(7 downto 0)
    );
end  Latched_Adder;

architecture arch of  Latched_Adder is 

    signal a : std_logic_vector(7 downto 0);
    signal b : std_logic_vector(7 downto 0);

begin
   
    process(nrst, clk)
    begin
        if nrst = '0' then
            b <= (others => '0');
            a <= (others => '0');
            
        elsif clk = '1' and clk'event then
            b <= InData;
            a <= b + "10";
        end if;

    end process;

    OutData <= a;


end arch;

