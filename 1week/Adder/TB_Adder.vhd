library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity TB_adder is
end TB_adder;

architecture behavior of TB_adder is

    component Adder port(
        nrst, clk : in std_logic;
        InData : in std_logic_vector(7 downto 0);
        OutData : out std_logic_vector(7 downto 0)
    );
    end component;

    component Adder_clk port(
        nrst, clk : in std_logic;
        InData : in std_logic_vector(7 downto 0);
        OutData : out std_logic_vector(7 downto 0)
    );
    end component;

    component cnt8bits port(
        nrst, clk : in std_logic;
        cntout : out std_logic_vector(7 downto 0)
    );
    end component;

    signal a_nrst : std_logic;
    signal a_clk : std_logic;
    signal a_cntout : std_logic_vector(7 downto 0);
    signal a_Outdata :  std_logic_vector(7 downto 0);
    signal a_OutData_clk :  std_logic_vector(7 downto 0);

    begin 
        u0 : cnt8bits port map(
            nrst => a_nrst,
            clk => a_clk,
            cntout => a_cntout
        );

        u1 : Adder port map(
            nrst => a_nrst,
            clk => a_clk,
            InData => a_cntout,
            OutData => a_OutData
        );

        u2 : Adder_clk port map(
            nrst => a_nrst,
            clk => a_clk,
            InData => a_cntout,
            OutData => a_OutData_clk
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

end behavior;        