library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_sampler is
end tb_sampler;

architecture behavior of tb_sampler is


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

    component QPSKmapper 
        port(
            nrst,pclk: in std_logic;    
            inbits : in std_logic_vector(1 downto 0);
    
            rdata : out std_logic_vector(5 downto 0);
            idata : out std_logic_vector(5 downto 0)
        );
    end  component;

    component QPSKdemapper 
        port(
            nrst,pclk: in std_logic;
            rdata : in std_logic_vector(5 downto 0);
            idata : in std_logic_vector(5 downto 0);
    
            outbits : out std_logic_vector(1 downto 0)
        );
    end  component;
   
    component QAM16mapper
        port(
            nrst,pclk: in std_logic;    
            inbits : in std_logic_vector(3 downto 0);
    
            rdata : out std_logic_vector(5 downto 0);
            idata : out std_logic_vector(5 downto 0)
        );
    end  component;

    component QAM16demapper 
        port(
            nrst,pclk: in std_logic;
            rdata : in std_logic_vector(5 downto 0);
            idata : in std_logic_vector(5 downto 0);
    
            outbits : out std_logic_vector(3 downto 0)
        );
    end  component;

    component UpSampler
    generic (tap : in integer);
    port(
        nrst,clk8x: in std_logic;            
        rdata : in std_logic_vector(5 downto 0);
        idata : in std_logic_vector(5 downto 0);
        out_rdata :  out std_logic_vector(5 downto 0);
        out_idata :  out std_logic_vector(5 downto 0)
    );
    end component;

    component DownSampler
    generic (tap : in integer);
    port(
        nrst,clk4x, clk1x: in std_logic;     
           
        rdata4x : in std_logic_vector(5 downto 0);
        idata4x : in std_logic_vector(5 downto 0);
        out_rdata1x :  out std_logic_vector(5 downto 0);
        out_idata1x :  out std_logic_vector(5 downto 0)
    );
    end component;
    

    signal nrst, mclk : std_logic;
    signal clk8x,clk4x,clk2x,clk1x : std_logic;
    signal rbit : std_logic;

    signal s2p_out : std_logic_vector(1 downto 0);
    signal s2p_out2 : std_logic_vector(3 downto 0);
    signal p2s_out : std_logic;
    signal p2s_out2 : std_logic;

    signal QPSKmap_out_i : std_logic_vector(5 downto 0);
    signal QPSKmap_out_r : std_logic_vector(5 downto 0);

    signal QAM16map_out_i : std_logic_vector(5 downto 0);
    signal QAM16map_out_r : std_logic_vector(5 downto 0);

    signal QPSKdemap_out : std_logic_vector(1 downto 0);
    signal QAM16demap_out : std_logic_vector(3 downto 0);

    signal UP4sample_out_i :  std_logic_vector(5 downto 0);
    signal UP4sample_out_r :  std_logic_vector(5 downto 0);

    signal UP8sample_out_i :  std_logic_vector(5 downto 0);
    signal UP8sample_out_r :  std_logic_vector(5 downto 0);

    signal DOWN4sample_out_i :  std_logic_vector(5 downto 0);
    signal DOWN4sample_out_r :  std_logic_vector(5 downto 0);

    signal DOWN8sample_out_i : std_logic_vector(5 downto 0);
    signal DOWN8sample_out_r :  std_logic_vector(5 downto 0);

    

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

        iqpskmap : QPSKmapper port map(

            nrst => nrst,
            pclk => clk2x,
            inbits => s2p_out,
            rdata => QPSKmap_out_r,
            idata => QPSKmap_out_i
            
        );

        iqpskdemap : QPSKdemapper port map(

            nrst => nrst,
            pclk => clk2x,
            rdata => DOWN4sample_out_r,
            idata => DOWN4sample_out_r,
            outbits => QPSKdemap_out
            
        );

        iqam16map : QAM16mapper port map(
            nrst => nrst,
            pclk => clk1x,
            inbits => s2p_out2,
            rdata => QAM16map_out_r,
            idata => QAM16map_out_i            
        );

        iqam16demap : QAM16demapper port map(
            nrst => nrst,
            pclk => clk1x,            
            rdata => DOWN8sample_out_r,
            idata => DOWN8sample_out_i,            
            outbits => QAM16demap_out
        );

        i4upsample : UpSampler 
                     generic map ( tap => 4)
                     port map(
            nrst => nrst,
            clk8x => clk8x,
            rdata => QPSKmap_out_r,
            idata => QPSKmap_out_i,
            out_rdata => UP4sample_out_r,
            out_idata => UP4sample_out_i            

        );

         i8upsample : UpSampler 
                     generic map ( tap => 8)
                     port map(
            nrst => nrst,
            clk8x => clk8x,
            rdata => QAM16map_out_r,
            idata => QAM16map_out_i,
            out_rdata => UP8sample_out_r,
            out_idata => UP8sample_out_i            

        );

        i4DownSampler : DownSampler
                        generic map ( tap => 4)
                        port map(
            nrst => nrst,
            clk4x => clk8x,
            clk1x => clk2x,	   
            rdata4x => UP4sample_out_r,
            idata4x =>  UP4sample_out_i,
            out_rdata1x => DOWN4sample_out_r,
            out_idata1x => DOWN4sample_out_i
        );

        i8DownSampler : DownSampler
                        generic map ( tap => 8)
                        port map(
            nrst => nrst,
            clk4x => clk8x,
            clk1x => clk1x,	   
            rdata4x => UP8sample_out_r,
            idata4x =>  UP8sample_out_i,
            out_rdata1x => DOWN8sample_out_r,
            out_idata1x => DOWN8sample_out_i
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