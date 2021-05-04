library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity tb_upconv is
end tb_upconv;

architecture behavior of tb_upconv is
   
component upconv 
    port(
    clk : in std_logic;
    nrst : in std_logic;
    base_r,base_i : in std_logic_vector(9 downto 0);
    pass_r, pass_i : out std_logic_vector(9 downto 0)
    );
end component;

signal nrst : std_logic;
signal clk : std_logic;
signal rin, iin : std_logic_vector(9 downto 0);
signal rout, iout : std_logic_vector(9 downto 0);

begin

    iup : upconv port map(
        nrst => nrst,
        clk => clk,
        base_r => rin,
        base_i => iin,

        pass_r => rout,
        pass_i => iout
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

    process(nrst, clk)
    begin
        if nrst = '0' then
            rin <= (others => '0');
            iin <= (others => '0');
        elsif clk = '1' and clk'event then
            rin <= rin + '1';
            iin <= iin - '1';
        end if;
    end process;

 end behavior;

