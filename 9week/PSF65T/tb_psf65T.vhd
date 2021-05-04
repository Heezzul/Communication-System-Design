library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.mypackage.all;

entity tb_psf65T is
end tb_psf65T;

architecture behavior of tb_psf65T is    

    component psf65T 
        port(
            nrst : in std_logic;
            clk : in std_logic;
            xin : in std_logic_vector(9 downto 0);
            fout : out std_logic_vector(9 downto 0)
        );
    end component;

    component clockgen port(
        nrst, mclk : in std_logic;   
   
        clk8x, clk4x, clk2x, clk1x : out std_logic
    );
    end component; 

    signal nrst, mclk : std_logic;
    signal clk8x,clk4x,clk2x,clk1x : std_logic;
    
    signal xin : std_logic_vector(9 downto 0);
    signal fout : std_logic_vector(9 downto 0);      
   

    begin


        iclkgen : clockgen port map(
            nrst => nrst,
            mclk => mclk,
            clk8x => clk8x,
            clk4x => clk4x,
            clk2x => clk2x,
            clk1x => clk1x
        );

        ipsf : psf65T
        port map(
            nrst => nrst,
            clk => clk8x,
            xin => xin,
            fout => fout
        );


         
        clkp : process
        begin
            mclk <= '1';
            wait for 20 ns;
            mclk <= '0';
            wait for 20 ns;
        end process;

        nrstp : process
        begin
            nrst <= '0';
            wait for 100 ns;
            nrst <= '1';
            wait;
        end process;

        inp : process
        begin
            xin <= "0000000000";
            wait for 140 ns;
            xin <= "0111111111";
            wait for 80 ns;
            xin <= "0000000000";
            wait;
        end process;

        
end behavior;        