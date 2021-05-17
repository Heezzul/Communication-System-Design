library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity UpConv_NCO is
port(
        nrst,clk : in std_logic;
        omega : in std_logic_vector(7 downto 0);
        base_r, base_i : in std_logic_vector(9 downto 0);
        pass_r, pass_i : out std_logic_vector(9 downto 0)
);
end UpConv_NCO;

architecture beh of UpConv_NCO is


    signal addr : std_logic_vector(7 downto 0);
    
    component CPX_mul_up 
        port(
            nrst, clk : in std_logic;
            base_r,base_i : in std_logic_vector(9 downto 0);
            NCO_r,NCO_i : in std_logic_vector(9 downto 0);
        
            pass_r,pass_i : out std_logic_vector(9 downto 0)
        
        );
    end component;

    component NCO 
        port(
            nrst,clk : in std_logic;
            addr : in std_logic_vector(7 downto 0);
            NCO_R, NCO_I : out std_logic_vector(9 downto 0)
        );
    end component;

    signal   NCO_R, NCO_I : std_logic_vector(9 downto 0)   ; 

begin

    inco : NCO port map(
        nrst => nrst,
        clk => clk,
        addr => addr,
        NCO_R => NCO_R,
        NCO_I => NCO_I
    );

    icpxmul_up : CPX_mul_up port map(
        nrst => nrst,
        clk => clk,
        base_r => base_r,
        base_i => base_i,
        NCO_r => NCO_R,
        NCO_i => NCO_I,
        pass_r => pass_r,
        pass_i => pass_i
    );

    iaddr : process(nrst, clk)
    begin
        if nrst = '0' then
            addr <= (others => '0');
        elsif clk = '1' and clk'event then
            addr <= addr + omega ;
        end if;
        end process;

end beh ;