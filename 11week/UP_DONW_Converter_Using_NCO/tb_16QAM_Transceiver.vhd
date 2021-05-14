library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_16QAM_Transceiver is
end tb_16QAM_Transceiver;

architecture behavior of tb_16QAM_Transceiver is


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
    

    component QAM16mapper 
        port(
            nrst,pclk: in std_logic;    
            inbits : in std_logic_vector(3 downto 0);
    
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

    component psf65T 
        port(
            nrst : in std_logic;
            clk : in std_logic;
            xin : in std_logic_vector(9 downto 0);
            fout : out std_logic_vector(9 downto 0)
        );
    end component;

    component QAM16demapper is
        port(
            nrst,pclk: in std_logic;
            rdata : in std_logic_vector(5 downto 0);
            idata : in std_logic_vector(5 downto 0);
    
            outbits : out std_logic_vector(3 downto 0)
        );
    end  component;

    component Parallel2Serial 
    generic (prate : in integer);
    port(
        nrst,sclk : in std_logic;    
        inbits : in std_logic_vector((prate -1) downto 0);   
        outbit : out std_logic
    );
    end component;

    component DownSampler
    generic (tap : in integer);
    port(
        nrst,clk4x, clk1x: in std_logic;                
        rdata4x : in std_logic_vector(9 downto 0);
        idata4x : in std_logic_vector(9 downto 0);
        out_rdata1x :  out std_logic_vector(9 downto 0);
        out_idata1x :  out std_logic_vector(9 downto 0)
    );
    end component;

    component UpConv_NCO 
        port(
                nrst,clk : in std_logic;
                omega : in std_logic_vector(7 downto 0);
                base_r, base_i : in std_logic_vector(9 downto 0);
                pass_r, pass_i : out std_logic_vector(9 downto 0)
        );
        end component;

    component DownConv_NCO 
        port(
        nrst,clk : in std_logic;
        omega : in std_logic_vector(7 downto 0);
        base_r, base_i : in std_logic_vector(9 downto 0);
        pass_r, pass_i : out std_logic_vector(9 downto 0)
        );
    end component;

    

    signal nrst, mclk : std_logic;
    signal clk8x,clk4x,clk2x,clk1x : std_logic;
    signal rbit : std_logic;

    signal s2p_out : std_logic_vector(3 downto 0);   
     

    signal QAM16map_out_i : std_logic_vector(5 downto 0);
    signal QAM16map_out_r : std_logic_vector(5 downto 0);   

    signal UP4sample_out_i :  std_logic_vector(5 downto 0);
    signal UP4sample_out_r :  std_logic_vector(5 downto 0);    

    signal psf_in_r : std_logic_vector(9 downto 0);
    signal psf_in_i : std_logic_vector(9 downto 0);

    signal psf_out_r : std_logic_vector(9 downto 0);
    signal psf_out_i : std_logic_vector(9 downto 0);

    signal upreal : std_logic_vector(9 downto 0);
    signal upimag :  std_logic_vector(9 downto 0);

    signal dnreal : std_logic_vector(9 downto 0);
    signal dnimag :  std_logic_vector(9 downto 0);

    signal psf_out_r_2 : std_logic_vector(9 downto 0);
    signal psf_out_i_2 : std_logic_vector(9 downto 0); 
    

    signal DOWN4sample_out_i :  std_logic_vector(9 downto 0);
    signal DOWN4sample_out_r :  std_logic_vector(9 downto 0);

    signal QAM16demap_in_r : std_logic_vector(5 downto 0);
    signal QAM16demap_in_i : std_logic_vector(5 downto 0);

    signal QAM16demap_out : std_logic_vector(3 downto 0);

    signal p2s_out : std_logic;

    signal omega : std_logic_vector(7 downto 0);

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
                generic map ( prate => 4) 
                port map(
            nrst => nrst,
            sclk => clk4x,
            pclk => clk1x,
            inbit => rbit,
            outbits => s2p_out
        );         

        iQAM16map : QAM16mapper port map(

            nrst => nrst,
            pclk => clk1x,
            inbits => s2p_out,
            rdata => QAM16map_out_r,
            idata => QAM16map_out_i
            
        );

      
        i4upsample : UpSampler 
                     generic map ( tap => 8)
                     port map(
            nrst => nrst,
            clk8x => clk8x,
            rdata => QAM16map_out_r,
            idata => QAM16map_out_i,
            out_rdata => UP4sample_out_r,
            out_idata => UP4sample_out_i            

        );

        psf_in_r <= UP4sample_out_r & "0000";
        psf_in_i <= UP4sample_out_i & "0000";

        ipsf_i : psf65T
        port map(
            nrst => nrst,
            clk => clk8x,
            xin => psf_in_i,
            fout => psf_out_i            
        );

        ipsf_r : psf65T
        port map(
            nrst => nrst,
            clk => clk8x,
            xin => psf_in_r,
            fout => psf_out_r            
        );

        omega <= "01000000";

        iup : UpConv_NCO port map(
            nrst => nrst,
            clk => clk8x,
            omega => omega,
            base_r => psf_out_r,
            base_i => psf_out_i,
    
            pass_r => upreal,
            pass_i => upimag
        );

        
        idn : DownConv_NCO port map(
            nrst => nrst,
            clk => clk8x,
            omega => omega,

            base_r => upreal,
            base_i => upimag,
    
            pass_r => dnreal,
            pass_i => dnimag
        );

        ipsf2_i : psf65T
        port map(
            nrst => nrst,
            clk => clk8x,
            xin => dnimag,           
            fout => psf_out_i_2           
        );

        ipsf2_r : psf65T
        port map(
            nrst => nrst,
            clk => clk8x,
            xin => dnreal,
            fout => psf_out_r_2            
        );
                 

        i4DownSampler : DownSampler
                        generic map ( tap => 8)
                        port map(
            nrst => nrst,
            clk4x => clk8x,
            clk1x => clk1x,	   
            rdata4x => psf_out_r_2,
            idata4x =>  psf_out_i_2,
            out_rdata1x => DOWN4sample_out_r,
            out_idata1x => DOWN4sample_out_i
        );

       --QPSKdemap_in_r <= DOWN4sample_out_r(9 downto 4);
       --QPSKdemap_in_i <= DOWN4sample_out_i(9 downto 4);

       process(DOWN4sample_out_r,DOWN4sample_out_i)
       begin
        if(DOWN4sample_out_r(3) = '1') then
            QAM16demap_in_r <= DOWN4sample_out_r(9 downto 4) + "000001";
        else
        QAM16demap_in_r <= DOWN4sample_out_r(9 downto 4);
        end if;
        if(DOWN4sample_out_i(3) = '1') then
            QAM16demap_in_i <= DOWN4sample_out_i(9 downto 4) + "000001";
        else
        QAM16demap_in_i <= DOWN4sample_out_i(9 downto 4);
        end if;
        end process;



        iqpskdemap : QAM16demapper port map(

            nrst => nrst,
            pclk => clk1x,
            rdata => QAM16demap_in_r,
            idata => QAM16demap_in_i,
            outbits => QAM16demap_out
            
        );

        ip2s2 : Parallel2Serial
                generic map ( prate => 4)
                port map(
            nrst => nrst,
            sclk => clk4x,
            inbits => QAM16demap_out,
            outbit => p2s_out
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