library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_counter is
end tb_counter;

architecture behavior of tb_counter is

    
    component counter port(
        nrst, clk : in std_logic;
        direction : in std_logic;
        cntout : out std_logic_vector(4 downto 0)
    );
    end component;

    signal a_nrst : std_logic;
    signal a_clk : std_logic;
    signal a_direction : std_logic;
    signal a_cntout : std_logic_vector(4 downto 0);   

    begin 
        u0 : counter port map(
            nrst => a_nrst,
            clk => a_clk,
            direction => a_direction,
            cntout => a_cntout
        );       

        clkp : process
        begin
            a_clk <= '1';
            wait for 20 ns;
            a_clk <= '0';
            wait for 20 ns;
        end process;

        nrstp : process
        begin
            a_nrst <= '0';
            wait for 85 ns;
            a_nrst <= '1';
            wait;
        end process;

        dirp : process
        begin 
            a_direction <= '0';
            wait for 1000 ns;
            a_direction <= '1';
            wait;
        end process;

end behavior;        