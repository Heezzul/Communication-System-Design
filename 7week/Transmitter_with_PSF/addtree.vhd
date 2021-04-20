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
        xvector_r : in std_10b_array(16 downto 0);
        xvector_i : in std_10b_array(16 downto 0);
        cvector : in std_10b_array(16 downto 0);
        sumout_r : out std_logic_vector(9 downto 0);
        sumout_i : out std_logic_vector(9 downto 0)  
    );
end addtree;

architecture behavior of addtree is 

    signal xmulh_r : std_20b_array(16 downto 0);
    signal xmulh_i : std_20b_array(16 downto 0);
    signal sum0_r : std_21b_array(7 downto 0);
    signal sum0_i : std_21b_array(7 downto 0);
    signal sum1_r : std_22b_array(3 downto 0);
    signal sum1_i : std_22b_array(3 downto 0);
    signal sum2_r : std_23b_array(1 downto 0);
    signal sum2_i : std_23b_array(1 downto 0);
    signal sum3_r : std_logic_vector(23 downto 0);
    signal sum3_i : std_logic_vector(23 downto 0);
    signal sum4_r : std_logic_vector(24 downto 0);   
    signal sum4_i : std_logic_vector(24 downto 0);

    begin
        stage0 : for i in 0 to 16 generate
        xmulh_r(i) <= xvector_r(i) * cvector(i);
        xmulh_i(i) <= xvector_i(i) * cvector(i);
        end generate;

        stage1 : for i in 0 to 7 generate
        sum0_r(i) <= sxt(xmulh_r(2*i),21) + sxt(xmulh_r(2*i+1),21);
        sum0_i(i) <= sxt(xmulh_i(2*i),21) + sxt(xmulh_i(2*i+1),21);
        end generate;

        stage2 : for i in 0 to 3 generate
        sum1_r(i) <= sxt(sum0_r(2*i),22) + sxt(sum0_r(2*i+1),22);
        sum1_i(i) <= sxt(sum0_i(2*i),22) + sxt(sum0_i(2*i+1),22);
        end generate;

        stage3 : for i in 0 to 1 generate
        sum2_r(i) <= sxt(sum1_r(2*i),23) + sxt(sum1_r(2*i+1),23);
        sum2_i(i) <= sxt(sum1_i(2*i),23) + sxt(sum1_i(2*i+1),23);
        end generate;

        sum3_r <= sxt(sum2_r(0),24) + sxt(sum2_r(1),24);
        sum3_i <= sxt(sum2_i(0),24) + sxt(sum2_i(1),24);
        sum4_r <= sxt(sum3_r,25) + sxt(xmulh_r(16),25);
        sum4_i <= sxt(sum3_i,25) + sxt(xmulh_i(16),25);

        sumout_r <= sum4_r(18 downto 9);
        sumout_i <= sum4_i(18 downto 9);

            
end behavior;
