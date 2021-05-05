library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.mypackage.all;

entity tdl_block is
    port(
        nrst : in std_logic;
        clk : in std_logic;
        xin : in std_logic_vector(9 downto 0);
        xvector : out std_10b_array(16 downto 0)
    );
end tdl_block;

architecture behavior of tdl_block is 


    signal xv : std_10b_array(16 downto 0);
      
    
    
begin   
    
    process(nrst, clk)
    begin
        if nrst = '0' then
            xv <= (others => "0000000000");
            
        elsif clk'event and clk = '1' then
	       xv(16) <= xin;
           xv(15 downto 0) <= xv(16 downto 1);
        end if;
    end process;
    
    xvector <= xv;

end behavior;
