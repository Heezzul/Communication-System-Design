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

    signal addr1 : std_logic_vector(7 downto 0);
    signal addr2 : std_logic_vector(7 downto 0);
    signal addr3 : std_logic_vector(7 downto 0);
    signal NCO_R1,NCO_I1 : std_logic_vector(9 downto 0);
    signal NCO_R2,NCO_I2 : std_logic_vector(9 downto 0);
    signal NCO_R3,NCO_I3 : std_logic_vector(9 downto 0);
    
begin

    iNCOtable1 : NCOtable
    port map(
        nrst => nrst,
        clk => clk,
        Address => addr1,
        NCO_R => NCO_R1,
        NCO_I => NCO_I1
    );
    
    iNCOtable2 : NCOtable
    port map(
        nrst => nrst,
        clk => clk,
        Address => addr2,
        NCO_R => NCO_R2,
        NCO_I => NCO_I2
    );

    iNCOtable3 : NCOtable
    port map(
        nrst => nrst,
        clk => clk,
        Address => addr3,
        NCO_R => NCO_R3,
        NCO_I => NCO_I3
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
            addr1 <= (others => '0');
            addr2 <= (others => '0');
            addr3 <= (others => '0');
        elsif clk = '1' and clk'event then
            addr1 <= addr1 + '1';
            addr2 <= addr2 + "00000010";
            addr3 <= addr3 + "01000000";
        end if;
        end process;

end behavior ;