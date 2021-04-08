library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity SimplePSF9 is
    port(
        nrst : in std_logic;
        clk : in std_logic;
        PSFin : in std_logic_vector(9 downto 0);
        PSFout : out std_logic_vector(9 downto 0)
    );
end SimplePSF9;

architecture arch of SimplePSF9 is 

    constant h0 :  std_logic-vector(9 downto 0):= conv_std_logic_vector(-13,10);
    constant h1 :  std_logic-vector(9 downto 0):= conv_std_logic_vector(65,10);
    constant h2 :  std_logic-vector(9 downto 0):= conv_std_logic_vector(161,10);
    constant h3 :  std_logic-vector(9 downto 0):= conv_std_logic_vector(239,10);
    constant h4 :  std_logic-vector(9 downto 0):= conv_std_logic_vector(270,10);
    constant h5 :  std_logic-vector(9 downto 0):= conv_std_logic_vector(239,10);
    constant h6 :  std_logic-vector(9 downto 0):= conv_std_logic_vector(161,10);
    constant h7 :  std_logic-vector(9 downto 0):= conv_std_logic_vector(65,10);
    constant h8 :  std_logic-vector(9 downto 0):= conv_std_logic_vector(-13,10);
    

    signal x0d, x1d, x2d, x3d, x4d, x5d, x6d, x7d, x8d : std_logic_vector(9 downto 0);
    signal x0dh0, x1dh1, x2dh2, x3dh3, x4dh4, x5dh5, x6dh6, x7dh7, x8dh8 : std_logic_vector(19 downto 0);
    signal sum01, sum23, sum56, sum78 : std_logic_vector(19 downto 0) ;
    signal sum0123, sum5678 : std_logic_vector(19 downto 0) ;
    signal sum01235678 : std_logic_vector(19 downto 0) ;
    signal sumall: std_logic_vector(19 downto 0) ;
    
    
begin
   
    x0d <= PSFin;
    process(nrst, mclk)
    begin
        if nrst = '0' then
           
           x8d <= (others => '0');
        elsif clk'event and clk = '1' then
            x1d <= x0d;
            x2d <= x1d;
            x3d <= x2d;
            x4d <= x3d;
            x5d <= x4d;
            x6d <= x5d;
            x7d <= x6d;
            x8d <= x7d;
        end if;
    end process;

    x0dh0 <= x0d * h0;
    x1dh1 <= x1d * h1;
    x2dh2 <= x2d * h2;
    x3dh0 <= x3d * h3;
    x4dh0 <= x4d * h4;
    x5dh0 <= x5d * h5;
    x6dh0 <= x6d * h6;
    x7dh0 <= x7d * h7;
    x8dh0 <= x8d * h8;     
    sum <= x0dh0 + x1dh1 + x2dh2 + x3dh3 + x4dh4 + x5dh5 + x6dh6 + x7dh7 + x8dh8

    PSHout <= sum(18 downto 9);
       

end arch;
