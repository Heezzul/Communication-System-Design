library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_DQPSK_Mapper is
end tb_DQPSK_Mapper;

architecture behavior of tb_DQPSK_Mapper is


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


    component DQPSKmapper 
        port(
            nrst,clk: in std_logic;    
            cdata : in std_logic_vector(1 downto 0);
    
            rout : out std_logic_vector(5 downto 0);
            iout : out std_logic_vector(5 downto 0)
        );
    end  component;
    
    signal nrst, mclk : std_logic;
    signal clk8x,clk4x,clk2x,clk1x : std_logic;
    signal rbit : std_logic;

    signal s2p_out : std_logic_vector(1 downto 0);   
     

    signal DQPSKmap_out_i : std_logic_vector(5 downto 0);
    signal DQPSKmap_out_r : std_logic_vector(5 downto 0);    

    begin 
        irbgen : rb12gen port map(
            nrst => nrst,
            clk => clk4x,
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

        idqpskmap : DQPSKmapper port map(

            nrst => nrst,
            clk => clk2x,
            cdata => s2p_out,
            rout => DQPSKmap_out_r,
            iout => DQPSKmap_out_i
            
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