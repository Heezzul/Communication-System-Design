library ieee;
use ieee.std_logic_1164.all;

entity DnConv_NCO_CR is
    port(
        nrst,clk1x, clk4x : in std_logic;
        pass_r, pass_i : in std_logic_vector(9 downto 0);
        base_r1x, base_i1x : in std_logic_vector(9 downto 0);
        base_r, base_r : out std_logic_vector(9 downto 0)
    );
end DnConv_NCO_CR;

architecture behavior of DnConv_NCO_CR is
   
    component CPX_mul_down 
        port(
            nrst, clk : in std_logic;
            base_r,base_i : in std_logic_vector(9 downto 0);
            NCO_r,NCO_i : in std_logic_vector(9 downto 0);
        
            pass_r,pass_i : out std_logic_vector(9 downto 0)
        
        );
    end component;
    
    component QPSK_PED 
    port(
        nrst : in std_logic;
        clk : in std_logic;
        rin, iin : in std_logic_vector(9 downto 0);
    
        Perr : out std_logic_vector(9 downto 0)
    );
    end component;
    

    component QPSK_LoopFilter 
        port(
            nrst : in std_logic;
            clk : in std_logic;
            Perr : in std_logic_vector(9 downto 0);
        
            LFout : out std_logic_vector(25 downto 0)
        );
    end component;    

    component QPSK_NCO
        port(
            nrst : in std_logic;
            clk : in std_logic;
            omega : in std_logic_vector(25 downto 0);
            LFout : in std_logic_vector(25 downto 0);
    
            NCO_I, NCO_Q : out std_logic_vector(9 downto 0)
        );
    end component;

    signal Perr : std_logic_vector(9 downto 0);
    signal LFout, omega : std_logic_vector(25 downto 0);
    signal NCO_I, NCO_Q : std_logic_vector(9 downto 0);

    begin

        iperr : QPSK_PED port map(nrst, clk1x, base_r1x,base_i1x, Perr);
        ilf : QPSK_LoopFilter port map(nrst, clk1x, Perr, LFout);

        omega <= "01000000100000000000000000"

        inco : QPSK_NCO port map(nrst, clk4x, omega, LFout, NCO_I,NCO_Q);

        icpxmul_dn : CPX_mul_down(nrst, clk4x, pass_r,pass_i,NCO_I,NCO_Q,base_r,base_i);

end behavior;
