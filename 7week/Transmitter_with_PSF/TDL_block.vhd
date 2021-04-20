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
        xin_r : in std_logic_vector(9 downto 0);
        xin_i : in std_logic_vector(9 downto 0);
        xvector_r : out std_10b_array(16 downto 0);
        xvector_i : out std_10b_array(16 downto 0)
    );
end tdl_block;

architecture behavior of tdl_block is 


    signal xv_r : std_10b_array(16 downto 0);
    signal xv_i : std_10b_array(16 downto 0);
      
    
    
begin   
    
    process(nrst, clk)
    begin
        if nrst = '0' then
            xv_r <= (others => "0000000000");
            xv_i <= (others => "0000000000");
            
        elsif clk'event and clk = '1' then
	       xv_r(16) <= xin_r;
           xv_i(16) <= xin_i;
           xv_r(15 downto 0) <= xv_r(16 downto 1);
           xv_i(15 downto 0) <= xv_i(16 downto 1);
        end if;
    end process;
    
    xvector_r <= xv_r;
    xvector_i <= xv_i;

end behavior;
