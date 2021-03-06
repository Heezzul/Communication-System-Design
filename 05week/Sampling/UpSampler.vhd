library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity UpSampler is
    generic (tap : in integer);
    port(
        nrst,clk8x: in std_logic;            
        rdata : in std_logic_vector(5 downto 0);
        idata : in std_logic_vector(5 downto 0);
        out_rdata :  out std_logic_vector(5 downto 0);
        out_idata :  out std_logic_vector(5 downto 0)
    );
end  UpSampler;

architecture arch of UpSampler is 
   
  
    signal cnt : integer range 0 to (tap-1);
   -- signal cnt2 : std_logic_vector (2 downto 0);
    signal sel : std_logic;


begin
   
    process(nrst, clk8x)
    begin
        if nrst = '0' then
            cnt <= 0;
        elsif clk8x = '1' and clk8x'event then
            if cnt = (tap-1) then
                cnt <= 0;
            else
                cnt <= cnt + 1;
            end if;
        end if;        
    end process;   

    sel <= '1' when cnt = tap-1 else '0';

    process(nrst, clk8x)
    begin
        if nrst = '0' then
            out_rdata <= (others => '0');
            out_idata <= (others => '0');
        elsif clk8x = '1' and clk8x'event then
            if sel = '1' then
                out_rdata <= rdata;
                out_idata <= idata;
            else
                out_rdata <= (others =>'0');
                out_idata <= (others =>'0');
            end if;
        end if;
    end process;

end arch;
