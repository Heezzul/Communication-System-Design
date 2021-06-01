library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

library work;
use work.mypackage.all;

entity PhaseSplitter is
    port(
        nrst : in std_logic;
        clk : in std_logic;
        PS_Iin : in std_logic_vector(9 downto 0);

        PS_Iout : out std_logic_vector(9 downto 0);
        PS_Qout : out std_logic_vector(9 downto 0)
    );
end PhaseSplitter;

architecture behavior of PhaseSplitter is

   signal reg : std_10b_array(14 downto 0);
   signal sub11b : std_11b_array(3 downto 0);
   signal sub21b : std_21b_array(3 downto 0);
   signal sum22b : std_22b_array(1 downto 0);  
   signal sum23b : std_logic_vector(22 downto 0);   

   constant coeff : std_10b_array(0 to 3) := std_10b_array'(
    conv_std_logic_vector(27,10),
    conv_std_logic_vector(45,10),
    conv_std_logic_vector(96,10),
    conv_std_logic_vector(321,10) 
    );

    begin 

    process(nrst, clk)
    begin
        if nrst = '0' then
            reg <= (others => "0000000000");
            --PS_Iout <= (others =>'0');
            --PS_Qout <= (others =>'0');
        elsif clk'event and clk = '1' then
            reg(14 downto 1) <= reg(13 downto 0);
            reg(0) <= PS_Iin;
                     
        end if;
    end process;

    stage0 : for i in 0 to 3 generate
    sub11b(i) <= sxt(reg(14-2*i),11) - sxt(reg(2*i),11);
    end generate;

    stage1 : for i in 0 to 3 generate
    sub21b(i) <= sub11b(i)*coeff(i);
    end generate;
    
    stage2 : for i in 0 to 1 generate
    sum22b(i) <= sxt(sub21b(2*i),22)+sxt(sub21b(2*i+1),22);
    end generate;    

    sum23b <= sxt(sum22b(0),23)+sxt(sum22b(1),23);   
    
    PS_Iout <= reg(7); 
    PS_Qout <=  rndsat(sum23b, 9, 4);     
    
        
end behavior;        