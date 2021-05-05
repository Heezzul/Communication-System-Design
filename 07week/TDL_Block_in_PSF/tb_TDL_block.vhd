library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.mypackage.all;

entity tb_tdl_block is
end tb_tdl_block;

architecture behavior of tb_tdl_block is

    component tdl_block 
        port(
            nrst : in std_logic;
            clk : in std_logic;
            xin : in std_logic_vector(9 downto 0);
            xvector : out std_10b_array(16 downto 0)
        );
    end component;

    signal nrst : std_logic;
    signal clk : std_logic;
    signal xin : std_logic_vector(9 downto 0);
    signal xvector : std_10b_array(16 downto 0);
   

    begin

        itdl : tdl_block
        port map(
            nrst => nrst,
            clk => clk,
            xin => xin,
            xvector => xvector
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

        process(nrst, clk)
        begin
            if nrst = '0' then
                xin <= (others => '0');               
            elsif clk = '1' and clk'event then
                xin <= xin + '1';
            end if;
        end process;
        
end behavior;        