library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_rb12gen is
end tb_rb12gen;

architecture behavior of tb_rb12gen is

    component rb12gen port(
        nrst, clk : in std_logic;       
        outbit : out std_logic
    );
    end component;   

    signal nrst : std_logic;
    signal clk : std_logic;
    signal rbit : std_logic;
    

    begin 
        irbgen : rb12gen port map(
            nrst => nrst,
            clk => clk,
            outbit => rbit
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