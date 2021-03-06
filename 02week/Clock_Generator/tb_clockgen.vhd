library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_clockgen is
end  tb_clockgen;

architecture behavior of  tb_clockgen is

    component clockgen port(
        nrst, mclk : in std_logic;   
   
        clk8x, clk4x, clk2x, clk1x : out std_logic
    );
    end component;   

    signal nrst : std_logic;
    signal clk : std_logic;
    signal clk8x : std_logic;
    signal clk4x : std_logic;
    signal clk2x : std_logic;
    signal clk1x : std_logic;
	
    

    begin 
        u1 : clockgen port map(
            nrst => nrst,
            mclk => clk,

            clk8x => clk8x,
            clk4x => clk4x,
            clk2x => clk2x,
            clk1x => clk1x
	
        );

             

        tb : process
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

end behavior;        