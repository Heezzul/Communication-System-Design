library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity tb_DQPSK_transceiver is
end tb_DQPSK_transceiver;

architecture behavior of tb_DQPSK_transceiver is


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

    component psf17T_sym 
    port(
        nrst : in std_logic;
        clk : in std_logic;
        xin : in std_logic_vector(9 downto 0);
        fout : out std_logic_vector(9 downto 0)
    );
    end component;

    component DQPSKdemapper 
    port(
        nrst,clk: in std_logic;    
        rdata, idata : in std_logic_vector(5 downto 0);

        outbits : out std_logic_vector(1 downto 0)
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

    component PhaseSplitter 
    port(
        nrst : in std_logic;
        clk : in std_logic;
        PS_Iin : in std_logic_vector(9 downto 0);

        PS_Iout : out std_logic_vector(9 downto 0);
        PS_Qout : out std_logic_vector(9 downto 0)
    );
    end component;

    signal nrst, mclk : std_logic;
    signal clk8x,clk4x,clk2x,clk1x : std_logic;
    signal rbit : std_logic;

    signal s2p_out : std_logic_vector(1 downto 0);   
     

    signal DQPSKmap_out_i : std_logic_vector(5 downto 0);
    signal DQPSKmap_out_r : std_logic_vector(5 downto 0);   

    signal UP4sample_out_i :  std_logic_vector(5 downto 0);
    signal UP4sample_out_r :  std_logic_vector(5 downto 0);    

    signal psf_in_r : std_logic_vector(9 downto 0);
    signal psf_in_i : std_logic_vector(9 downto 0);

    signal psf_out_r : std_logic_vector(9 downto 0);
    signal psf_out_i : std_logic_vector(9 downto 0);

    signal upreal : std_logic_vector(9 downto 0);
    signal upimag :  std_logic_vector(9 downto 0);

    signal PS_Iout : std_logic_vector(9 downto 0);
    signal PS_Qout :  std_logic_vector(9 downto 0);  

    signal dnreal : std_logic_vector(9 downto 0);
    signal dnimag :  std_logic_vector(9 downto 0);

    signal psf_out_r_2 : std_logic_vector(9 downto 0);
    signal psf_out_i_2 : std_logic_vector(9 downto 0); 
    

    signal DOWN4sample_out_i :  std_logic_vector(9 downto 0);
    signal DOWN4sample_out_r :  std_logic_vector(9 downto 0);

    signal DQPSKdemap_in_r : std_logic_vector(5 downto 0);
    signal DQPSKdemap_in_i : std_logic_vector(5 downto 0);

    signal DQPSKdemap_out : std_logic_vector(1 downto 0);

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

      
        i4upsample : UpSampler 
                     generic map ( tap => 4)
                     port map(
            nrst => nrst,
            clk8x => clk8x,
            rdata => DQPSKmap_out_r,
            idata => DQPSKmap_out_i,
            out_rdata => UP4sample_out_r,
            out_idata => UP4sample_out_i            

        );

        psf_in_r <= UP4sample_out_r & "0000";
        psf_in_i <= UP4sample_out_i & "0000";

        ipsf_i : psf17T_sym
        port map(
            nrst => nrst,
            clk => clk8x,
            xin => psf_in_i,
            fout => psf_out_i            
        );

        ipsf_r : psf17T_sym
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

        ips : PhaseSplitter port map(
            nrst => nrst,
            clk => clk8x,
            PS_Iin => upreal,
            PS_Iout => PS_Iout,
            PS_Qout => PS_Qout       
        );      

        
        idn : DownConv_NCO port map(
            nrst => nrst,
            clk => clk8x,
            omega => omega,

            base_r => PS_Iout,
            base_i => PS_Qout,
    
            pass_r => dnreal,
            pass_i => dnimag
        );

        ipsf2_i : psf17T_sym
        port map(
            nrst => nrst,
            clk => clk8x,
            xin => dnimag,           
            fout => psf_out_i_2           
        );

        ipsf2_r : psf17T_sym
        port map(
            nrst => nrst,
            clk => clk8x,
            xin => dnreal,
            fout => psf_out_r_2            
        );
                 

        i4DownSampler : DownSampler
                        generic map ( tap => 4)
                        port map(
            nrst => nrst,
            clk4x => clk8x,
            clk1x => clk2x,	   
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
            DQPSKdemap_in_r <= DOWN4sample_out_r(9 downto 4) + "000001";
        else
            DQPSKdemap_in_r <= DOWN4sample_out_r(9 downto 4);
        end if;
        if(DOWN4sample_out_i(3) = '1') then
            DQPSKdemap_in_i <= DOWN4sample_out_i(9 downto 4) + "000001";
        else
            DQPSKdemap_in_i <= DOWN4sample_out_i(9 downto 4);
        end if;
        end process;



        idqpskdemap : DQPSKdemapper port map(

            nrst => nrst,
            clk => clk2x,
            rdata => DQPSKdemap_in_r,
            idata => DQPSKdemap_in_i,
            outbits => DQPSKdemap_out
            
        );

        ip2s2 : Parallel2Serial
                generic map ( prate => 2)
                port map(
            nrst => nrst,
            sclk => clk4x,
            inbits => DQPSKdemap_out,
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