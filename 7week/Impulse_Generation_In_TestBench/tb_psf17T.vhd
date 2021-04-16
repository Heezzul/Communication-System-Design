clkp : process
        begin
            clk <= '1';
            wait for 20 ns;
            clk <= '0';
            wait for 20 ns;
        end process;

        nrstp : process
        begin
            nrst <= '0';
            wait for 100 ns;
            nrst <= '1';
            wait;
        end process;

        process(nrst, clk)
        begin
            if nrst = '0' then
                xin <= (others => '0');               
            elsif clk = '1' and clk'event then
                xin <= xin + '1';
            end if;
        end process;