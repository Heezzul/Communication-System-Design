library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DownSampler is
    port(
        nrst,clk4x, clk1x: in std_logic;     
          
        rdata4x : in std_logic_vector(5 downto 0);
        idata4x : in std_logic_vector(5 downto 0);
        out_rdata1x :  out std_logic_vector(5 downto 0);
        out_idata1x :  out std_logic_vector(5 downto 0)
    );
end  DownSampler;

architecture arch of DownSampler is  
  
    
    signal rd4xsym : std_logic_vector (5 downto 0);
    signal id4xsym : std_logic_vector (5 downto 0);

    signal rdata4x_del_1, idata4x_del_1 : std_logic_vector (5 downto 0);
    signal rdata4x_del_2, idata4x_del_2 : std_logic_vector (5 downto 0);
    signal rdata4x_del_3, idata4x_del_3 : std_logic_vector (5 downto 0);


begin
   
    
    process(nrst, clk4x)
    begin     
        if nrst = '0' then
	        rdata4x_del_1 <= (others => '0');
            idata4x_del_1 <= (others => '0'); 
	        rdata4x_del_2  <= (others => '0');
            idata4x_del_2 <= (others => '0');    
	        rdata4x_del_3 <= (others => '0');
            idata4x_del_3 <= (others => '0');       
  
        elsif clk4x = '1' and clk4x'event then
            
            rdata4x_del_1 <= rdata4x;
            idata4x_del_1 <= idata4x;

            rdata4x_del_2 <= rdata4x_del_1;
            idata4x_del_2 <= idata4x_del_1;

            rdata4x_del_3 <= rdata4x_del_2;
            idata4x_del_3 <= idata4x_del_2;

           
        end if;
    end process;

    process(nrst, clk1x)
    begin
        if nrst = '0' then
            rd4xsym <= (others => '0');
            id4xsym <= (others => '0');                             
        elsif clk1x = '1' and clk1x'event then

            if dsel = "00" then
                rd4xsym <= rdata4x;
                rd4xsym <= idata4x;
            elsif dsel = "01" then

                rd4xsym <= rdata4x_del_1;
                rd4xsym <= idata4x_del_1;      

            elsif dsel = "10" then             
            
                rd4xsym <= rdata4x_del_2;
                rd4xsym <= idata4x_del_2;    

            elsif dsel = "11" then                

                rd4xsym <= rdata4x_del_3;
                id4xsym <= idata4x_del_3;        
            end if;

            
        end if; 
    end process;

    out_rdata1x <=  rd4xsym;
    out_idata1x <=  id4xsym;

end arch;
