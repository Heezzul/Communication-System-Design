library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.mypackage.all;

entity tb_psf17T is
end tb_psf17T;

architecture behavior of tb_psf17T is

    component psf17T 
        port(
            nrst : in std_logic;
            clk : in std_logic;
            xin : in std_logic_vector(9 downto 0);
            fout : out std_logic_vector(9 downto 0)
        );
    end component;

    signal nrst : std_logic;
    signal clk : std_logic;
    signal xin : std_logic_vector(9 downto 0);
    signal fout : std_logic_vector(9 downto 0);
   

    begin

        ipsf : psf17T
        port map(
            nrst => nrst,
            clk => clk,
            xin => xin,
            fout => fout
        );
   
        clkp : process
        begin
            clk <= '1';
            wait for 20 ns;
            clk <= '0';
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
            wait for 40 ns;
            xin <= "0000000000";
            wait;
        end process;

        
end behavior;        