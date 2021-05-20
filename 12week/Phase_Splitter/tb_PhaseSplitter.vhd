library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.mypackage.all;

entity tb_PhaseSplitter is
end tb_PhaseSplitter;

architecture behavior of tb_PhaseSplitter is

    component PhaseSplitter 
        port(
            nrst : in std_logic;
            clk : in std_logic;
            PS_Iin : in std_logic_vector(9 downto 0);
    
            PS_Iout : out std_logic_vector(9 downto 0);
            PS_Qout : out std_logic_vector(9 downto 0)
        );
    end component;

    signal nrst : std_logic;
    signal clk : std_logic;
    signal PS_Iin : std_logic_vector(9 downto 0);
    signal PS_Iout : std_logic_vector(9 downto 0);
    signal PS_Qout : std_logic_vector(9 downto 0);
   

    begin

        iPS : PhaseSplitter
        port map(
            nrst => nrst,
            clk => clk,
            PS_Iin => PS_Iin,
            PS_Iout => PS_Iout,
            PS_Qout => PS_Qout
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
            PS_Iin <= "0000000000";
            wait for 140 ns;
            PS_Iin <= "0111111111";
            wait for 40 ns;
            PS_Iin <= "0000000000";
            wait;
        end process;

        
end behavior;        