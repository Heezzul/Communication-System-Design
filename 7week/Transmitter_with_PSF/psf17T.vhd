library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

library work;
use work.mypackage.all;

entity psf17T is
    port(
        nrst : in std_logic;
        clk : in std_logic;
        xin_r : in std_logic_vector(9 downto 0);
        xin_i : in std_logic_vector(9 downto 0);
        fout_r : out std_logic_vector(9 downto 0);
        fout_i : out std_logic_vector(9 downto 0)
    );
end psf17T;

architecture behavior of psf17T is

    component addtree 
        port(
           nrst : in std_logic;
           clk : in std_logic;
           xvector_r : in std_10b_array(16 downto 0);
           xvector_i : in std_10b_array(16 downto 0);
           cvector : in std_10b_array(16 downto 0);
           sumout_r : out std_logic_vector(9 downto 0);
           sumout_i : out std_logic_vector(9 downto 0)  
        );
    end component;

    component tdl_block 
        port(
            nrst : in std_logic;
            clk : in std_logic;
            xin_r : in std_logic_vector(9 downto 0);
            xin_i : in std_logic_vector(9 downto 0);
            xvector_r : out std_10b_array(16 downto 0);
            xvector_i : out std_10b_array(16 downto 0)
        );
    end component;

    component cvgen
        port(
            cvector : out std_10b_array(16 downto 0)
        );
    end component;
   
    
    signal xvector_i,xvector_r,cvector : std_10b_array(16 downto 0);
   

    begin

        itdl : tdl_block
        port map(
            nrst => nrst,
            clk => clk,
            xin_r => xin_r,
            xin_i => xin_i,
            xvector_r => xvector_r,
            xvector_i => xvector_i
        );

        icvgen : cvgen
        port map(
            cvector => cvector
        );

        iaddtree : addtree 
        port map(
            nrst => nrst,
            clk => clk,
            xvector_r => xvector_r,
            xvector_i => xvector_i,
            cvector => cvector,
            sumout_r => fout_r,
            sumout_i => fout_i
        ); 
        
        
end behavior;        