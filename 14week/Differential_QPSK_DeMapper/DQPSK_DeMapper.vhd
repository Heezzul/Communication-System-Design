library ieee;
use ieee.std_logic_1164.all;


entity DQPSKdemapper is
    port(
        nrst,clk: in std_logic;    
        rdata, idata : in std_logic_vector(5 downto 0);

        outbits : out std_logic_vector(1 downto 0)
    );
end  DQPSKdemapper;

architecture arch of DQPSKdemapper is 
   
    component QPSKdemapper 
        port(
            nrst,pclk: in std_logic;
            rdata : in std_logic_vector(5 downto 0);
            idata : in std_logic_vector(5 downto 0);
    
            outbits : out std_logic_vector(1 downto 0)
        );
    end  component;

    signal y,cdata, pdata : std_logic_vector(1 downto 0);


begin
   
    process(cdata, pdata)
    begin
        if pdata = "00" then
            y <= cdata;
        elsif pdata = "01" then
            if cdata = "00" then
                y <= "10";
            elsif cdata = "01" then
                y <= "00";
            elsif cdata = "10" then
                y <= "11";
            else 
                y <= "01";
            end if;
        elsif pdata = "10" then
            if cdata = "00" then
                y <= "01";
            elsif cdata = "01" then
                y <= "11";
            elsif cdata = "10" then
                y <= "00";
            else 
                y <= "10";
            end if;
        else
            if cdata = "00" then
                y <= "11";
            elsif cdata = "01" then
                y <= "10";
            elsif cdata = "10" then
                y <= "01";
            else 
                y <= "00";
            end if;
        end if;
    end process;

    process(nrst, clk)
    begin
        if nrst = '0' then
           -- cdata <= (others => '0');
            pdata <= (others => '0');
        elsif clk'event and clk = '1' then
            pdata <= cdata;
        end if;
    end process;

    iqpskdemap : QPSKdemapper port map(

        nrst => nrst,
        pclk => clk,
        rdata => rdata,
        idata => idata,
        outbits => cdata
        
    );

    outbits <= y;



end arch;
