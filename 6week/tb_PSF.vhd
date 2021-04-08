library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_PSF is
end tb_PSF;

architecture behavior of tb_PSF is


   
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
            wait for 140ns;
            xin <= "0111111111";
            wait for 40ns ;
            xin <= "0000000000";
            wait
        end process;

end behavior;        