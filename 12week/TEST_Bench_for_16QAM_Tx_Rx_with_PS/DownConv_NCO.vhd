library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DownConv_NCO is
port(
        nrst,clk : in std_logic;
        omega : in std_logic_vector(7 downto 0);
        base_r, base_i : in std_logic_vector(9 downto 0);
        pass_r, pass_i : out std_logic_vector(9 downto 0)
);
end DownConv_NCO;

architecture beh of DownConv_NCO is

    signal addr : std_logic_vector(7 downto 0);
    component CPX_mul_down 
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

    signal   NCO_R, NCO_I : std_logic_vector(9 downto 0) ;   
    signal   NCO_R1d, NCO_I1d : std_logic_vector(9 downto 0) ;   
    signal   NCO_R2d, NCO_I2d : std_logic_vector(9 downto 0) ;    

begin

    inco : NCO port map(
        nrst => nrst,
        clk => clk,
        addr => addr,
        NCO_R => NCO_R,
        NCO_I => NCO_I
    );

    icpxmul_up : CPX_mul_down port map(
        nrst => nrst,
        clk => clk,
        base_r => base_r,
        base_i => base_i,
        NCO_r => NCO_R2d,
        NCO_i => NCO_I2d,
        pass_r => pass_r,
        pass_i => pass_i
    );

    process(nrst, clk)
    begin
        if nrst = '0' then
            NCO_R1d <= (others => '0');
            NCO_I1d <= (others => '0');
            NCO_R2d <= (others => '0');
         NCO_I2d <= (others => '0');            
     elsif clk = '1' and clk'event then
         NCO_R1d <= NCO_R;
         NCO_I1d <= NCO_I;
         NCO_R2d <= NCO_R1d;
         NCO_I2d <= NCO_I1d;           
     end if;
 end process;



 iaddr : process(nrst, clk)
 begin
     if nrst = '0' then
         addr <= (others => '0');
     elsif clk = '1' and clk'event then
         addr <= addr + omega ;
     end if;
     end process;

end beh ;