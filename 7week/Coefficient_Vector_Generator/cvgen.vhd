library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

library work;
use work.mypackage.all;

entity cvgen is
    port(
        cvector : out std_10b_array(16 downto 0)
    );
end cvgen;

architecture behavior of cvgen is 

constant coeff : std_10b_array(16 downto 0) := std_10b_array'(
    conv_std_logic_vector(14,10),
    conv_std_logic_vector(-14,10),
    conv_std_logic_vector(-44,10),
    conv_std_logic_vector(-51,10),
    conv_std_logic_vector(-16,10),
    conv_std_logic_vector(61,10),
    conv_std_logic_vector(159,10),
    conv_std_logic_vector(241,10),
    conv_std_logic_vector(273,10),
    conv_std_logic_vector(241,10),
    conv_std_logic_vector(159,10),
    conv_std_logic_vector(61,10),
    conv_std_logic_vector(-16,10),
    conv_std_logic_vector(-51,10),
    conv_std_logic_vector(-44,10),
    conv_std_logic_vector(-14,10),
    conv_std_logic_vector(14,10)
    );

    begin
        cvector <= coeff;
            
end behavior;
