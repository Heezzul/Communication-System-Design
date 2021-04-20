library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_transmitter_PSF is
end tb_transmitter_PSF;

architecture behavior of tb_transmitter_PSF is


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

    component psf17T 
    port(
        nrst : in std_logic;
        clk : in std_logic;
        xin_r : in std_logic_vector(9 downto 0);
        xin_i : in std_logic_vector(9 downto 0);
        fout_r : out std_logic_vector(9 downto 0);
        fout_i : out std_logic_vector(9 downto 0)
    );
    end component;

    

    signal nrst, mclk : std_logic;
    signal clk8x,clk4x,clk2x,clk1x : std_logic;
    signal rbit : std_logic;

    signal s2p_out : std_logic_vector(1 downto 0);   
     

    signal QPSKmap_out_i : std_logic_vector(5 downto 0);
    signal QPSKmap_out_r : std_logic_vector(5 downto 0);   

    signal UP4sample_out_i :  std_logic_vector(5 downto 0);
    signal UP4sample_out_r :  std_logic_vector(5 downto 0);    

    signal psf_in_r : std_logic_vector(9 downto 0);
    signal psf_in_i : std_logic_vector(9 downto 0);

    signal psf_out_r : std_logic_vector(9 downto 0);
    signal psf_out_i : std_logic_vector(9 downto 0);

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

        iqpskmap : QPSKmapper port map(

            nrst => nrst,
            pclk => clk2x,
            inbits => s2p_out,
            rdata => QPSKmap_out_r,
            idata => QPSKmap_out_i
            
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

        psf_in_r <= UP4sample_out_r & "0000";
        psf_in_i <= UP4sample_out_i & "0000";

        ipsf : psf17T
        port map(
            nrst => nrst,
            clk => clk8x,
            xin_r => psf_in_r,
            xin_i => psf_in_i,
            fout_r => psf_out_r,
            fout_i => psf_out_i
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