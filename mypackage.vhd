---------------------------------------------------------------------------------
--
-- Package of some arithmatics for filter
--
--
---------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

package mypackage is
  
  -------------------------------------------------------------------------------
  -- Defining two dimensional arrays
  -------------------------------------------------------------------------------
  type std_2b_array is array (natural range <>) of std_logic_vector(1 downto 0);
  type std_3b_array is array (natural range <>) of std_logic_vector(2 downto 0);
  type std_4b_array is array (natural range <>) of std_logic_vector(3 downto 0);
  type std_5b_array is array (natural range <>) of std_logic_vector(4 downto 0);
  type std_6b_array is array (natural range <>) of std_logic_vector(5 downto 0);
  type std_7b_array is array (natural range <>) of std_logic_vector(6 downto 0);
  type std_8b_array is array (natural range <>) of std_logic_vector(7 downto 0);
  type std_9b_array is array (natural range <>) of std_logic_vector(8 downto 0);
  type std_10b_array is array (natural range <>) of std_logic_vector(9 downto 0);
  type std_11b_array is array (natural range <>) of std_logic_vector(10 downto 0);
  type std_12b_array is array (natural range <>) of std_logic_vector(11 downto 0);
  type std_13b_array is array (natural range <>) of std_logic_vector(12 downto 0);
  type std_14b_array is array (natural range <>) of std_logic_vector(13 downto 0);
  type std_15b_array is array (natural range <>) of std_logic_vector(14 downto 0);
  type std_16b_array is array (natural range <>) of std_logic_vector(15 downto 0);
  type std_17b_array is array (natural range <>) of std_logic_vector(16 downto 0);
  type std_18b_array is array (natural range <>) of std_logic_vector(17 downto 0);
  type std_19b_array is array (natural range <>) of std_logic_vector(18 downto 0);
  type std_20b_array is array (natural range <>) of std_logic_vector(19 downto 0);
  type std_21b_array is array (natural range <>) of std_logic_vector(20 downto 0);
  type std_22b_array is array (natural range <>) of std_logic_vector(21 downto 0);
  type std_23b_array is array (natural range <>) of std_logic_vector(22 downto 0);
  type std_24b_array is array (natural range <>) of std_logic_vector(23 downto 0);
  type std_25b_array is array (natural range <>) of std_logic_vector(24 downto 0);
  type std_26b_array is array (natural range <>) of std_logic_vector(25 downto 0);
  type std_27b_array is array (natural range <>) of std_logic_vector(26 downto 0);
  type std_28b_array is array (natural range <>) of std_logic_vector(27 downto 0);
  type std_29b_array is array (natural range <>) of std_logic_vector(28 downto 0);
  type std_30b_array is array (natural range <>) of std_logic_vector(29 downto 0);
  type std_31b_array is array (natural range <>) of std_logic_vector(30 downto 0);


  -------------------------------------------------------------------------------
  --  rounding function rnd( a, rndbit)
  --           a: input vector to be rounded
  --           rndbit : number of bits to be rounded.
  --           result : return vector of size = length(a) - rndbit
  --   +---------------------------------+-----------------------+
  --   |            result               | to be rounded(rndbit) |
  --   +---------------------------------+-----------------------+
  -------------------------------------------------------------------------------
  function rnd(a: std_logic_vector; rndbit: integer) return std_logic_vector;
  -------------------------------------------------------------------------------
  --  saturator function sat( a, satbit)
  --           a: input vector to be saturated
  --           satbit : number of bits to be saturated.
  --           result : return vector of size = length(a) - satbit
  --   +------------------------+--------------------------------+
  --   |to be saturated(satbit) |            result              |
  --   +------------------------+--------------------------------+
  -------------------------------------------------------------------------------
  function sat(a: std_logic_vector; satbit: integer) return std_logic_vector;
  -------------------------------------------------------------------------------
  --  saturator function sat( a, rndbit, satbit)
  --           a: input vector to be saturated
  --           rndbit : number of bits to be rounded.
  --           satbit : number of bits to be saturated.
  --           result : return vector of size = length(a) - rndbit - satbit
  --   +------------------------+--------------------------------+-----------+
  --   |to be saturated(satbit) |            result              | rnd bits  |
  --   +------------------------+--------------------------------+-----------+
  -------------------------------------------------------------------------------
  function rndsat(a: std_logic_vector; rndbit:integer; satbit: integer) return std_logic_vector;

end mypackage;

package body mypackage is

  -------------------------------------------------------------------------------
  --  rounding function rnd( a, rndbit)
  --           a: input vector to be rounded
  --           rndbit : number of bits to be rounded.
  --           result : return vector of size = length(a) - rndbit
  --   +---------------------------------+-----------------------+
  --   |            result               | to be rounded(rndbit) |
  --   +---------------------------------+-----------------------+
  -------------------------------------------------------------------------------
  function rnd(a: std_logic_vector; rndbit: integer) return std_logic_vector is
    constant len: integer := a'length - 1;
    variable sign, round, sticky: std_logic ;
    variable maxvalue, result, one: std_logic_vector((len-rndbit) downto 0);
  begin
    sign := a(len) ;
    round := a(rndbit-1) ;
    sticky := '0' ;
    for  i in 0 to (rndbit-2) loop
    sticky := a(i) or sticky ;
    end loop ;

    result := a(len downto rndbit) ;

    if (((sign and round) = '1') and (sticky = '0')) then
            return(result) ;
    else
        maxvalue := (others => '1') ;
        maxvalue(len-rndbit) := '0' ;
        if ( (round = '1') and (SIGNED(result) /= SIGNED(maxvalue))) then
                result := SIGNED(result) + 1 ;
        end if ;
    end if;
    return (result) ;
  end rnd ;

  -------------------------------------------------------------------------------
  --  saturator function sat( a, satbit)
  --           a: input vector to be saturated
  --           satbit : number of bits to be saturated.
  --           result : return vector of size = length(a) - satbit
  --   +------------------------+--------------------------------+
  --   |to be saturated(satbit) |            result              |
  --   +------------------------+--------------------------------+
  -------------------------------------------------------------------------------
  function sat(a: std_logic_vector; satbit: integer) return std_logic_vector is
    constant len: integer := a'length - 1;
    variable result: std_logic_vector((len-satbit) downto 0);
    variable sign, ov: std_logic ;
  begin
    if ( satbit <= 0 )
        then return(a) ;
    else
        sign := a(len) ;
        ov := '0' ;

        for i in (len-satbit) to len loop
            ov := ov or (a(i) xor sign) ;
        end loop ;

        if ( ov = '1') then
            result := (others => not sign) ;
            result(len-satbit) := sign ;
        else
            result := a((len-satbit) downto 0);
        end if ;
    end if ;
    return (result) ;
  end sat ;

  -------------------------------------------------------------------------------
  --  saturator function rndsat( a, rndbit, satbit)
  --           a: input vector to be saturated
  --           rndbit : number of bits to be rounded.
  --           satbit : number of bits to be saturated.
  --           result : return vector of size = length(a) - rndbit - satbit
  --   +------------------------+--------------------------------+-----------+
  --   |to be saturated(satbit) |            result              | rnd bits  |
  --   +------------------------+--------------------------------+-----------+
  -------------------------------------------------------------------------------
  function rndsat(a: std_logic_vector; rndbit:integer; satbit: integer) return std_logic_vector is
    constant len: integer := a'length -1 ;
    variable rndout : std_logic_vector((len-rndbit) downto 0);
    variable satout : std_logic_vector((len-rndbit-satbit) downto 0) ;
  begin
    rndout := rnd(a,rndbit) ;
    satout := sat(rndout,satbit) ;
    return satout ;
  end rndsat ;
  
end mypackage;
