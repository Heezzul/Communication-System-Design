library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_QPSK_Tranceiver is
end tb_QPSK_Tranceiver;

architecture behavior of tb_QPSK_Tranceiver is


    component clockgen port(
        nrst, mclk : in std_logic;   
   
        clk8x, clk4x, clk2x, clk1x : out std_logic
    );
    end component;  

    component rb12gen port(
        nrst, clk : in std_logic;       
        rbit : out std_logic
    );
    end component;   

    component Serial2Parallel port(
        nrst,sclk,pclk : in std_logic;    
        inbit : in std_logic;   
        outbits : out std_logic_vector(1 downto 0)
    );
    end component;   

    component Parallel2Serial port(
        nrst,sclk : in std_logic;    
        inbits : in std_logic_vector(1 downto 0);   
        outbit : out std_logic
    );
    end component;

    component QPSKmapper port(
        nrst,pclk: in std_logic;    
        inbits : in std_logic_vector(1 downto 0);

        rdata : out std_logic_vector(5 downto 0);
        idata : out std_logic_vector(5 downto 0)
    );
    end component;

    component QPSKdemapper port(
        nrst,pclk: in std_logic;
        rdata : in std_logic_vector(5 downto 0);
        idata : in std_logic_vector(5 downto 0);

        outbits : out std_logic_vector(1 downto 0)
    );
    end component;

    signal nrst, mclk : std_logic;
    signal clk8x,clk4x,clk2x,clk1x : std_logic;
    signal rbit : std_logic;
    

    signal tx_outbits : std_logic_vector(1 downto 0);
    
    signal rmapout : std_logic_vector(5 downto 0);
    signal qmapout : std_logic_vector(5 downto 0);

    signal rx_outbits : std_logic_vector(1 downto 0);

    signal Finalbit : std_logic;

    

    begin 

        iclkgen : clockgen port map(
            nrst => nrst,
            mclk => mclk,
            clk8x => clk8x,
            clk4x => clk4x,
            clk2x => clk2x,
            clk1x => clk1x
        );

        irbgen : rb12gen port map(
            nrst => nrst,
            clk => clk2x,
            rbit => rbit
        );

        is2p : Serial2Parallel port map(
            nrst => nrst,
            sclk => clk2x,
            pclk => clk1x,
            inbit => rbit,
            outbits => tx_outbits
        );        

        iQPSKmapper : QPSKmapper port map(
            nrst => nrst,
            pclk => clk1x,
            inbits => tx_outbits,
            rdata => rmapout,
            idata => qmapout
        );

        iQPSKdemapper : QPSKdemapper port map(
            nrst => nrst,
            pclk => clk1x,           
            rdata => rmapout,
            idata => qmapout,
            outbits => rx_outbits
        );

        ip2s : Parallel2Serial port map(
            nrst => nrst,
            sclk => clk2x,
            inbits => rx_outbits,
            outbit => Finalbit
        );



        tb : process
        begin
            mclk <= '1';
            wait for 20 ns;
            mclk <= '0';
            wait for 20 ns;
        end process;

        nrstp : process
        begin
            nrst <= '0';
            wait for 100 ns;
            nrst <= '1';
            wait;
        end process;

end behavior;        