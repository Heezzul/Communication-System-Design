library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.mypackage.all;

entity CPX_mul_up is
port(
    nrst, clk : in std_logic;
    base_r,base_i : in std_logic_vector(9 downto 0);
    NCO_r,NCO_i : in std_logic_vector(9 downto 0);

    pass_r,pass_i : out std_logic_vector(9 downto 0)

);
end CPX_mul_up;

architecture beh of CPX_mul_up is

    signal base_r_d,base_i_d : std_logic_vector(9 downto 0);
    signal NCO_r_d,NCO_i_d : std_logic_vector(9 downto 0);
    signal mul0,mul1,mul2,mul3 :  std_logic_vector(19 downto 0);
    signal sum0,sum1 : std_logic_vector(20 downto 0);

begin


    process(nrst, clk)
    begin
        if nrst = '0' then
            pass_r <= (others => '0');
            pass_i <= (others => '0');
            base_r_d <= (others => '0');
            base_i_d <= (others => '0');
            NCO_r_d <= (others => '0');
            NCO_i_d <= (others => '0');
        elsif clk = '1' and clk'event then   
            base_r_d <= base_r;
            base_i_d <= base_i;
            NCO_r_d <= NCO_r;
            NCO_i_d <= NCO_i; 
            pass_r <=  rndsat(sum0, 9, 2 );   
            pass_i <=  rndsat(sum1, 9, 2 );        
        end if;            
    end process;

    mul0 <= base_r_d*NCO_r_d;
    mul1 <= base_i_d*NCO_i_d;
    mul2 <= base_i_d*NCO_r_d;
    mul3 <= base_r_d*NCO_i_d;

    sum0 <= sxt(mul0,21) - sxt(mul1,21);
    sum1 <= sxt(mul2,21) + sxt(mul3,21);



end beh;