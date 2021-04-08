library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tb_PSF is
end tb_PSF;

architecture behavior of tb_PSF is

    component SimplePSF9 
        port(
            nrst : in std_logic;
            clk : in std_logic;
            PSFin : in std_logic_vector(9 downto 0);
            PSFout : out std_logic_vector(9 downto 0)
        );
    end component;

    signal nrst : std_logic;
    signal clk : std_logic;
    signal impulse, impout : std_logic_vector(9 downto 0);

    begin

        iPSF9 : SimplePSF9
        port map(
            nrst => nrst,
            clk => clk,
            PSFin => impulse,
            PSFout => impout
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
            impulse <= "0000000000";
            wait for 140 ns;
            impulse <= "0111111111";
            wait for 40 ns ;
            impulse <= "0000000000";
            wait;
        end process;

end behavior;        