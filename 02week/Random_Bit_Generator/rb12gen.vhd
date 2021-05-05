library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity rb12gen is
    port(
        nrst,clk : in std_logic;       
        outbit : out std_logic
    );
end  rb12gen;

architecture arch of rb12gen is 

    signal reg : std_logic_vector(11 downto 0);
    
begin
   
    process(nrst, clk)
    begin
        if nrst = '0' then
            reg <= "100000100101";
            
        elsif clk = '1' and clk'event then
           reg(0) <= reg(5) xor reg(7) xor reg(10) xor reg(11);
           reg(11 downto 1) <= reg(10 downto 0);
        end if;

    end process;

    outbit <= reg(11);


end arch;
