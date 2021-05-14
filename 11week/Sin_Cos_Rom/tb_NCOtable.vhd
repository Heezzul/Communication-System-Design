library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_NCOtable is
end tb_NCOtable;

architecture behavior of tb_NCOtable is

    component NCOtable is
        port(
            nrst,clk : in std_logic;
            Address : in std_logic_vector(7 downto 0);
            NCO_R, NCO_I : out std_logic_vector(9 downto 0)
        );
    end component;

    signal nrst : std_logic;
    signal clk : std_logic;

    signal addr : std_logic_vector(7 downto 0);
    signal NCO_R,NCO_I : std_logic_vector(9 downto 0);
    
begin

    iNCOtable : NCOtable
    port map(
        nrst => nrst,
        clk => clk,
        Address => addr,
        NCO_R => NCO_R,
        NCO_I => NCO_I
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

    iaddr : process(nrst, clk)
    begin
        if nrst = '0' then
            addr <= (others => '0');
        elsif clk = '1' and clk'event then
            addr <= addr + '1';
        end if;
        end process;

end behavior ;