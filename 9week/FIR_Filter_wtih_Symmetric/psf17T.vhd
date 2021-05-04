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
        xin : in std_logic_vector(9 downto 0);
        fout : out std_logic_vector(9 downto 0)
    );
end psf17T;

architecture behavior of psf17T is

    component addtree 
        port(
           nrst : in std_logic;
           clk : in std_logic;
           xvector : in std_10b_array(16 downto 0);
           cvector : in std_10b_array(16 downto 0);
           sumout : out std_logic_vector(9 downto 0) 
        );
    end component;

    component tdl_block 
        port(
            nrst : in std_logic;
            clk : in std_logic;
            xin : in std_logic_vector(9 downto 0);
            xvector : out std_10b_array(16 downto 0)
        );
    end component;

    component cvgen
        port(
            cvector : out std_10b_array(16 downto 0)
        );
    end component;
   
    
    signal xvector,cvector : std_10b_array(16 downto 0);
    signal fout_d : std_logic_vector(9 downto 0);
   
    

    begin

        itdl : tdl_block
        port map(
            nrst => nrst,
            clk => clk,
            xin => xin,
            xvector => xvector
        );

        icvgen : cvgen
        port map(
            cvector => cvector
        );

        iaddtree : addtree 
        port map(
            nrst => nrst,
            clk => clk,
            xvector => xvector,
            cvector => cvector,
            sumout => fout_d
        ); 
        
        process(nrst, clk)
    begin
        if nrst = '0' then
            fout <= (others =>'0'); 
        elsif clk'event and clk = '1' then
            fout <= fout_d;
            
        end if;
    end process;
   
        
end behavior;        