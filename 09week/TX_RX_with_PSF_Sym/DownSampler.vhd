library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DownSampler is
    generic (tap : in integer);
    port(
        nrst,clk4x, clk1x: in std_logic;                
        rdata4x : in std_logic_vector(9 downto 0);
        idata4x : in std_logic_vector(9 downto 0);
        out_rdata1x :  out std_logic_vector(9 downto 0);
        out_idata1x :  out std_logic_vector(9 downto 0)
    );
end  DownSampler;

architecture arch of DownSampler is  
  
    
    signal cnt : integer range 0 to (tap-1);
    signal sel : std_logic;
    signal r_dndata : std_logic_vector(9 downto 0);
    signal i_dndata : std_logic_vector(9 downto 0);



begin
   
    
    process(nrst, clk4x)
    begin     
        if nrst = '0' then
            cnt <= 0;
        elsif clk4x = '1' and clk4x'event then
            if cnt = (tap-1) then
                cnt <= 0;
            else
                cnt <= cnt + 1;
            end if;
        end if;

        
    end process;
    sel <='1' when cnt = 0 else '0';

    process(nrst, clk4x)
    begin     
        if nrst = '0' then
            r_dndata <= (others => '0');
            i_dndata <= (others => '0');
        elsif clk4x = '1' and clk4x'event then
           if sel = '1' then
                r_dndata <= rdata4x;
                i_dndata <= idata4x;
            
            end if;
        end if;       
    end process;

    process(nrst, clk1x)
    begin
        if nrst = '0' then
            out_rdata1x <= (others => '0');
            out_idata1x <= (others => '0');                             
        elsif clk1x = '1' and clk1x'event then

            out_rdata1x <= r_dndata;
            out_idata1x <= i_dndata;           
          
            
        end if; 
    end process;

    
end arch;
