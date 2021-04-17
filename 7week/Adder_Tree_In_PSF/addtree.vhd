library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

library work;
use work.mypackage.all;

entity addtree is
    port(
       nrst : in std_logic;
       clk : in std_logic;
       xvector : in std_10b_array(16 downto 0);
       cvector : in std_10b_array(16 downto 0);
       sumout : out std_logic_vector(9 downto 0) 
    );
end addtree;

architecture behavior of addtree is 

    signal xmulh : std_20b_array(16 downto 0);
    signal sum0 : std_21b_array(7 downto 0);
    signal sum1 : std_22b_array(3 downto 0);
    signal sum2 : std_23b_array(1 downto 0);
    signal sum3 : std_logic_vector(23 downto 0);
    signal sum4 : std_logic_vector(24 downto 0);

    begin
        stage0 : for i in 0 to 16 generate
        xmulh(i) <= xvector(i) * cvector(i);
        end generate;

        stage1 : for i in 0 to 7 generate
        sum0(i) <= sxt(xmulh(2*i),21) + sxt(xmulh(2*i+1),21);
        end generate;

        stage2 : for i in 0 to 3 generate
        sum1(i) <= sxt(sum0(2*i),22) + sxt(sum0(2*i+1),22);
        end generate;

        stage3 : for i in 0 to 1 generate
        sum2(i) <= sxt(sum1(2*i),23) + sxt(sum1(2*i+1),23);
        end generate;

        sum3 <= sxt(sum2(0),24) + sxt(sum2(1),24);
        sum4 <= sxt(sum3,25) + sxt(xmulh(16),25);

        sumout <= sum4(18 downto 9);

            
end behavior;
