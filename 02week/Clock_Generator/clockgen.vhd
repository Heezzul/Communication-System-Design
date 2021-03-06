library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clockgen is
    port(
        nrst, mclk : in std_logic;   

        clk8x, clk4x, clk2x, clk1x : out std_logic
    );
end clockgen;

architecture arch of clockgen is 

    signal cnt : std_logic_vector(3 downto 0);
    
begin
   
    process(nrst, mclk)
    begin
        if nrst = '0' then
           
           cnt <= (others => '0');
            
        elsif mclk = '1' and mclk'event then
          cnt <= cnt + '1';	
	 
        end if;
    end process;
 	  
clk8x <= cnt(0);
clk4x <= cnt(1);
clk2x <= cnt(2);
clk1x <= cnt(3);
    

end arch;
