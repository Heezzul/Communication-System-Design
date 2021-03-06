library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_latchedadder is
end tb_latchedadder;

architecture behavior of tb_latchedadder is

    component Latched_Adder port(
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

    begin 
        u0 : cnt8bits port map(
            nrst => a_nrst,
            clk => a_clk,
            cntout => a_cntout
        );

        u1 : Latched_Adder port map(
            nrst => a_nrst,
            clk => a_clk,
            InData => a_cntout,
            OutData => a_OutData
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
            wait for 100 ns;
            a_nrst <= '1';
            wait;
        end process;

end behavior;        