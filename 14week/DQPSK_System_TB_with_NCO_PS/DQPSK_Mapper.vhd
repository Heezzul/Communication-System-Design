library ieee;
use ieee.std_logic_1164.all;


entity DQPSKmapper is
    port(
        nrst,clk: in std_logic;    
        cdata : in std_logic_vector(1 downto 0);

        rout : out std_logic_vector(5 downto 0);
        iout : out std_logic_vector(5 downto 0)
    );
end  DQPSKmapper;

architecture arch of DQPSKmapper is 
   
    component QPSKmapper 
        port(
            nrst,pclk: in std_logic;    
           inbits : in std_logic_vector(1 downto 0);

            rdata : out std_logic_vector(5 downto 0);
            idata : out std_logic_vector(5 downto 0)
        );
    end  component;

    signal y, pdata : std_logic_vector(1 downto 0);


begin
   
    process(cdata, pdata)
    begin
        if cdata = "00" then
            y <= pdata;
        elsif cdata = "01" then
            if pdata = "00" then
                y <= "01";
            elsif pdata = "01" then
                y <= "11";
            elsif pdata = "10" then
                y <= "00";
            else 
                y <= "10";
            end if;
        elsif cdata = "10" then
            if pdata = "00" then
                y <= "10";
            elsif pdata = "01" then
                y <= "00";
            elsif pdata = "10" then
                y <= "11";
            else 
                y <= "01";
            end if;
        else
            if pdata = "00" then
                y <= "11";
            elsif pdata = "01" then
                y <= "10";
            elsif pdata = "10" then
                y <= "01";
            else 
                y <= "00";
            end if;
        end if;
    end process;

    process(nrst, clk)
    begin
        if nrst = '0' then
            pdata <= (others => '0');
        elsif clk'event and clk = '1' then
            pdata <= y;
        end if;
    end process;

    iqpskmap : QPSKmapper port map(

            nrst => nrst,
            pclk => clk,
            inbits => y,
            rdata => rout,
            idata => iout
            
        );



end arch;
