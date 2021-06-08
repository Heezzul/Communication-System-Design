LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;


entity QPSK_NCO is
    port(
        nrst : in std_logic;
        clk : in std_logic;
        omega : in std_logic_vector(25 downto 0);
        LFout : in std_logic_vector(25 downto 0);

        NCO_I, NCO_Q : out std_logic_vector(9 downto 0)
    );
end QPSK_NCO;

architecture beh of QPSK_NCO is

    component NCOtable
    port(
        nrst, clk : in std_logic;
        Address : in std_logic_vector(7 downto 0);
        NCO_I, NCO_Q : out std_logic_vector(9 downto 0)
    );
    end component;

    signal NCO_Acc, dphase : std_logic_vector(25 downto 0);
    signal addr : std_logic_vector(7 downto 0);

    begin

        process(nrst, clk)
        begin
            if nrst = '0' then
                dphase <= (others => '0');
            elsif clk = '1' and clk'event then
                dphase <= LFout + omega;
            end if;
        end process;

        process(nrst, clk)
        begin

            if nrst = '0' then
                NCO_Acc <= (others => '0');
            elsif clk = '1' and clk'event then
                NCO_Acc <= NCO_Acc + dphase;
            end if;
        end process;

        addr <= NCO_Acc (25 downto 18);

        iNCOtable : NCOtable port map(
            nrst => nrst,
            clk => clk,
            Address => addr,
            NCO_I => NCO_I,
            NCO_Q => NCO_Q
        );

end beh;