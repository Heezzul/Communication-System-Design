library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

LIBRARY work;
USE work.mypackage.all;

entity tdl_blcok is
    port(
        nrst : in std_logic;
        clk : in std_logic;
        xin : in std_logic_vector(9 downto 0);
        xvector : out std_10bit_array(16 downto 0)
    );
end tdl_blcok;

architecture behavior of SimplePSF9 is 


    signal xv :  std_10bit_array(16 downto 0);
      
    
    
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
