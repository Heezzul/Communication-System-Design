library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Adder is
    port(
        nrst,clk : in std_logic;
        InData : in std_logic_vector(7 downto 0);
        OutData : out std_logic_vector(7 downto 0)
    );
end Adder;

architecture arch of Adder is 

    signal a : std_logic_vector(7 downto 0);

begin
    a<= InData +"00000010";
    OutData <= a;

end arch;

