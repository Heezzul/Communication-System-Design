library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_Parallel2Serial is
end tb_Parallel2Serial;

architecture behavior of tb_Parallel2Serial is


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

    component Serial2Parallel
    generic(prate : in integer);
    port(
        nrst,sclk,pclk : in std_logic;    
        inbit : in std_logic;   
        outbits : out std_logic_vector((prate -1) downto 0)
    );
    end component;   

    component Parallel2Serial 
        generic (prate : in integer);
        port(
            nrst,sclk : in std_logic;    
            inbits : in std_logic_vector((prate -1) downto 0);   
            outbit : out std_logic
        );
    end component;

    signal nrst, mclk : std_logic;
    signal clk8x,clk4x,clk2x,clk1x : std_logic;
    signal rbit : std_logic;

    signal s2p_out : std_logic_vector(1 downto 0);
    signal s2p_out2 : std_logic_vector(3 downto 0);
    signal p2s_out : std_logic;
    signal p2s_out2 : std_logic;



    

    begin 
        irbgen : rb12gen port map(
            nrst => nrst,
            clk => clk2x,
            rbit => rbit
        );

        

        iclkgen : clockgen port map(
            nrst => nrst,
            mclk => mclk,
            clk8x => clk8x,
            clk4x => clk4x,
            clk2x => clk2x,
            clk1x => clk1x
        );

        is2p2 : Serial2Parallel
                generic map ( prate => 2) 
                port map(
            nrst => nrst,
            sclk => clk4x,
            pclk => clk2x,
            inbit => rbit,
            outbits => s2p_out
        );     

        is2p4 : Serial2Parallel
                generic map ( prate => 4)
                port map(
            nrst => nrst,
            sclk => clk4x,
            pclk => clk1x,
            inbit => rbit,
            outbits => s2p_out2
         );     

         ip2s2 : Parallel2Serial
                generic map ( prate => 2)
                port map(
            nrst => nrst,
            sclk => clk4x,
            inbits => s2p_out,
            outbit => p2s_out
        );

        ip2s4 : Parallel2Serial
                generic map ( prate => 4)
                port map(
            nrst => nrst,
            sclk => clk4x,
            inbits => s2p_out2,
            outbit => p2s_out2
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