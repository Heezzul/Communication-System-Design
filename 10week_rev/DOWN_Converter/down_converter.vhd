library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity dnconv is
    port(
    clk : in std_logic;
    nrst : in std_logic;
    base_r,base_i : in std_logic_vector(9 downto 0);
    pass_r, pass_i : out std_logic_vector(9 downto 0)
    );
end dnconv;

architecture arch of dnconv is

  signal cnt : integer range 0 to 3;
  signal p_r,p_i,n_r,n_i : std_logic_vector(9 downto 0);
  
begin
   
    p_r <= base_r;
    p_i <= base_i;
    n_r <= not(base_r) + "0000000001";
    n_i <= not(base_i) + "0000000001";

    process(nrst, clk)
    begin     
        if nrst = '0' then
            cnt <= 3;
        elsif clk = '1' and clk'event then
            if cnt = 3 then
                cnt <= 0;
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    process(nrst, clk)
    begin     
        if nrst = '0' then            
            pass_r <= (others => '0');
            pass_i <= (others => '0');
        elsif clk = '1' and clk'event then
            if cnt = 0 then
                pass_r <= p_r;
                pass_i <= p_i;
            elsif cnt = 1 then
                pass_r <= p_i;
                pass_i <= n_r;
             elsif cnt = 2 then
                pass_r <= n_r;
                pass_i <= n_i;
            elsif cnt = 3 then
                pass_r <= n_i;
                pass_i <= p_r;    
            end if;
        end if;
    end process;
    


 end arch;