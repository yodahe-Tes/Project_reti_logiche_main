----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Yodahe Teshome Kumbi  & Shaffaeet Mohammad
-- 
-- Create Date: 19.07.2022 10:29:43
-- Design Name: 
-- Module Name: project_reti_logiche - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;



entity project_reti_logiche is port (
    i_clk         : in  std_logic;
    i_start       : in  std_logic;
    i_rst         : in  std_logic;
    i_data        : in  std_logic_vector(7 downto 0);
    o_address     : out std_logic_vector(15 downto 0);
    o_done        : out std_logic;
    o_en          : out std_logic;
    o_we          : out std_logic;
    o_data        : out std_logic_vector (7 downto 0)
);
end project_reti_logiche;

architecture behavioural of project_reti_logiche is
component datapath is port (
    i_clk: in std_logic;
    i_rst: in std_logic;
    i_start : in std_logic;
    i_data: in std_logic_vector(7 downto 0);
    o_address: out std_logic_vector (15 downto 0);
    o_data: out std_logic_vector (7 downto 0);

    o_bit_count: out std_logic_vector(2 downto 0);
    o_byte_total: out std_logic_vector(7 downto 0);
    
    r1_load: in std_logic;
    r2_load: in std_logic;
    r3_load: in std_logic;
    r4_load: in std_logic;
    r5_load: in std_logic;
    r6_load: in std_logic;
    r7_load: in std_logic;
    r8_load: in std_logic;
    r11_load: in std_logic;
    r12_load: in std_logic;

    m_inp_add_sel: in std_logic;
    m_outp_add_sel: in std_logic;
    m_in_or_out_sel: in std_logic;
    m_cont_sel: in std_logic;
    m_reset_sel: in std_logic
);
end component datapath;

type S is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S12);
signal cur_state, next_state : S;

signal r1_load: std_logic;
signal r2_load: std_logic;
signal r3_load: std_logic;
signal r4_load: std_logic;
signal r5_load: std_logic;
signal r6_load: std_logic;
signal r7_load: std_logic;
signal r8_load: std_logic;
signal r11_load: std_logic;
signal r12_load: std_logic;

signal m_inp_add_sel: std_logic;
signal m_outp_add_sel: std_logic;
signal m_in_or_out_sel: std_logic;
signal m_cont_sel: std_logic;
signal m_reset_sel: std_logic;
signal m1_bit_sel: std_logic_vector(2 downto 0);                        -- aggiunto da Yoda

signal dp_o_address: std_logic_vector(15 downto 0);
signal dp_o_bit_count: std_logic_vector(2 downto 0);
signal dp_o_byte_total: std_logic_vector(7 downto 0);

begin
    --segnali esterni
    DATAPATH0: datapath port map(
        i_clk => i_clk,
        i_rst => i_rst,
        i_start => i_start,
        i_data => i_data,
        
        o_address => dp_o_address,
        o_data => o_data,

        o_bit_count => dp_o_bit_count,      
        o_byte_total => dp_o_byte_total,
        
        r1_load => r1_load,
        r2_load => r2_load,
        r3_load => r3_load,
        r4_load => r4_load,
        r5_load => r5_load,
        r6_load => r6_load,
        r7_load => r7_load,
        r8_load => r8_load,
        r11_load => r11_load,
        r12_load => r12_load,

        m_inp_add_sel => m_inp_add_sel,
        m_outp_add_sel => m_outp_add_sel,
        m_in_or_out_sel => m_in_or_out_sel,
        m_cont_sel => m_cont_sel,
        m_reset_sel => m_reset_sel
    );
    
    o_address <= dp_o_address;
     
    process(i_clk, i_rst)
        begin
            if(i_rst = '1') then
                cur_state <= S0;
            elsif i_clk'event and i_clk = '1' then
                cur_state <= next_state;
            end if;
        end process;
        
   process(i_clk, i_rst,i_start,cur_state,dp_o_address)
    begin
        next_state <= cur_state;
        case cur_state is
            when S0 =>
                if i_start = '1' then
                    next_state <= S1;
                end if;
            when S1 =>
                next_state <= S2;
            when S2 =>
                next_state <= S3;
            when S3 =>
                next_state <= S4;
            when S4 =>
                if dp_o_address -1  = dp_o_byte_total  then
                    next_state <= S12;
                else next_state <= S5;
                end if; 
            when S5 =>
                next_state <= S6;
            when S6 =>
                next_state <= S7;
            when S7 =>
                next_state <= S8;
            when S8 =>
                next_state <= S9;
            when S9 =>
                next_state <= S10;
            when S10 =>
                next_state <= S3;
            when S12 =>
                if i_start = '0' then
                    next_state <= S0;
                else next_state <= S12;
                end if;
        end case;
    end process;
    
    process(cur_state)
    begin
        o_we <= '0';
        o_done <= '0';
        o_en <= '1';
        r1_load <= '0';
        r2_load <= '0';
        m_reset_sel <= '1';    
        r3_load <= '0';
        r4_load <= '0';
        r5_load <= '0';
        r6_load <= '0';
        r7_load <= '0';
        r8_load <= '0';
        r11_load <= '0';
        r12_load <= '0';
        m_in_or_out_sel <= '0';
        m_inp_add_sel <= '1';
        m_outp_add_sel <= '1';
        m_cont_sel <= '1';
--  
           case cur_state is
             when S0 =>
                o_done <= '0';
                o_en <= '0';
                 m_inp_add_sel <= '0';
                 m_outp_add_sel <= '0';
                 m_cont_sel <= '0';
                 m_reset_sel <= '0';
                 r1_load <= '1';
                 r2_load <= '1';
            when S1 =>
                m_cont_sel <= '0';
                r12_load <= '1';
                m_inp_add_sel <= '0';
                r7_load <= '1';
                m_outp_add_sel <= '0';
                r8_load <= '1';
                m_reset_sel <= '0';

              
            when S2 =>
                o_en <= '1';
                o_we <= '0';
                r11_load <= '1';--
                m_cont_sel <= '1';
                r12_load <= '0';
                m_inp_add_sel <= '1';
               r7_load <= '0';
                m_outp_add_sel <= '1';
                r8_load <= '0';
                m_reset_sel <= '0';
                r1_load <= '1';
                r2_load <= '1';
                m_in_or_out_sel <= '0';
            when S3 =>
                r8_load <= '0';
                --
                if dp_o_address = "0000" then
                r11_load <= '1'; 
                else r11_load <= '0';
                end if;
                if dp_o_bit_count = "000" then
                    r7_load <= '1';
                else r7_load <= '0';
                end if;
 
            when S4 =>
               r7_load <= '0';
            when S5 =>
                r1_load <= '1';
                r2_load <= '1';
                r3_load <= '1';
                r12_load <= '1';
            when S6 =>
                r4_load <= '1'; 
                r1_load <= '1';
                r2_load <= '1';
                r12_load <= '1';
            when S7 =>
                 r4_load <= '0';
                 r1_load <= '1';
                 r2_load <= '1';
                 r5_load <= '1';
                 r12_load <= '1';
            when S8 =>
                r1_load <= '1';
                r2_load <= '1';        
                r5_load <= '0';
                r6_load <= '1';
                r12_load <= '1';
            when S9 =>
                r6_load <= '0';
                r1_load <= '0';
                r2_load <= '0';
                r12_load <= '0';
                m_in_or_out_sel <= '1';
                o_en <= '1';
                o_we <= '1';
            when S10 =>
                r8_load <= '1';
                m_in_or_out_sel <= '0';        
            when S12 =>
                o_done <= '1';
        end case;
    end process;
    
end behavioural;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity datapath is port (
    i_clk: in std_logic;
    i_rst: in std_logic;
    i_start : in std_logic;
    i_data: in std_logic_vector(7 downto 0);

    o_address: out std_logic_vector (15 downto 0);
    o_data: out std_logic_vector (7 downto 0);
    
    o_bit_count: out std_logic_vector(2 downto 0);
    o_byte_total: out std_logic_vector(7 downto 0);

    r1_load: in std_logic;
    r2_load: in std_logic;
    r3_load: in std_logic;
    r4_load: in std_logic;
    r5_load: in std_logic;
    r6_load: in std_logic;
    r7_load: in std_logic;
    r8_load: in std_logic;
    r11_load: in std_logic;
    r12_load: in std_logic;

    m_inp_add_sel: in std_logic;
    m_outp_add_sel: in std_logic;
    m_in_or_out_sel: in std_logic;
    m_cont_sel: in std_logic;
    m_reset_sel: in std_logic
);
end datapath;

architecture behavioural of datapath is

-- segnali intermedi
signal uk00 : std_logic_vector(7 downto 0);
signal uk0 : std_logic;
signal uk1 : std_logic;
signal uk2 : std_logic;
signal yk : std_logic_vector(1 downto 0):= "00";
signal p1k : std_logic;
signal p2k : std_logic;

signal r3_out : std_logic_vector(1 downto 0):= "00";
signal r4_out : std_logic_vector(1 downto 0):= "00";
signal r5_out : std_logic_vector(1 downto 0):= "00";
signal r6_out : std_logic_vector(1 downto 0):= "00";

signal m1_bit_sel : std_logic_vector(2 downto 0):= "000";   --
signal m1_out : std_logic:= '0';
signal m_cont_out : std_logic_vector(2 downto 0):= "000";
signal m_cont_in : std_logic_vector(2 downto 0):= "000";
signal m_cont_inp_in : std_logic_vector(15 downto 0):= "0000000000000000";
signal m_cont_outp_in : std_logic_vector(15 downto 0):= "0000000000000000";
signal inp_add : std_logic_vector(15 downto 0):= "0000000000000001";
signal m_inp_cont_out : std_logic_vector(15 downto 0):= "0000000000000000";
signal m_outp_cont_out : std_logic_vector(15 downto 0):= "0000000000000000";
signal outp_add : std_logic_vector(15 downto 0):= "0000000000000000";

begin
    uk00 <= i_data;
    
    m1_out <= uk00(7) when m1_bit_sel = "000" else
              uk00(6) when m1_bit_sel = "001" else
              uk00(5) when m1_bit_sel = "010" else
              uk00(4) when m1_bit_sel = "011" else
              uk00(3) when m1_bit_sel = "100" else
              uk00(2) when m1_bit_sel = "101" else
              uk00(1) when m1_bit_sel = "110" else
              uk00(0);                 
        
    m_cont_out <= "000" when m_cont_sel = '0' else m_cont_in;
        
    r1: process(i_clk, i_rst)
        begin
            if(i_rst = '1') then
                uk1 <= '0';
            elsif i_clk'event and i_clk = '1' then
                if(r1_load = '1') then
                    uk1 <= uk0; 
                end if;
            end if;
        end process;
        
    r2: process(i_clk, i_rst)
        begin
            if(i_rst = '1') then
                uk2 <= '0';
            elsif i_clk'event and i_clk = '1' then
                if(r2_load = '1') then
                    uk2 <= uk1; 
                end if;
            end if;
        end process;

    r3: process(i_clk, i_rst)
        begin
            if(i_rst = '1') then
                r3_out <= "00";
            elsif i_clk'event and i_clk = '1' then
                if(r3_load = '1') then
                    r3_out <= yk;
                end if;
            end if;
        end process;
        
    r4: process(i_clk, i_rst)
        begin
            if(i_rst = '1') then
                r4_out <= "00";
            elsif i_clk'event and i_clk = '1' then
                if(r4_load = '1') then
                    r4_out <= yk;
                end if;
            end if;
        end process;
        
    r5: process(i_clk, i_rst)
        begin
            if(i_rst = '1') then
                r5_out <= "00";
            elsif i_clk'event and i_clk = '1' then
                if(r5_load = '1') then
                    r5_out <= yk;
                end if;
            end if;
        end process;
        
    r6: process(i_clk, i_rst)
        begin
            if(i_rst = '1') then
                r6_out <= "00";
            elsif i_clk'event and i_clk = '1' then
                if(r6_load = '1') then
                    r6_out <= yk;
                end if;
            end if;
        end process;
        
    r7: process(i_clk, i_rst)
        begin
            if(i_rst = '1') then
                inp_add <= "0000000000000000";
            elsif i_clk'event and i_clk = '1' then
                if(r7_load = '1') then
                    inp_add <= m_inp_cont_out; 
                end if;
            end if;
        end process;
                
    r8: process(i_clk, i_rst)
        begin
            if(i_rst = '1') then
                outp_add <= "0000001111101000";
            elsif i_clk'event and i_clk = '1' then
                if(r8_load = '1') then
                    outp_add <= m_outp_cont_out; 
                end if;
            end if;
        end process;
    
    o_address <= inp_add when m_in_or_out_sel = '0' else outp_add;

    o_data <= r3_out & r4_out & r5_out & r6_out when i_rst='0' else (others => '0');
    
    r11: process(i_clk, i_rst)                                       
         begin
            if(i_rst = '1') then
                o_byte_total <= "00000000";
            elsif i_clk'event and i_clk = '1' then
                if(r11_load = '1') then
                    o_byte_total <= i_data;
                end if;
            end if;
        end process;    

    r12: process(i_clk, i_rst)
        begin
            if(i_rst = '1') then
                m1_bit_sel <= "000";
            elsif i_clk'event and i_clk = '1' then
                if(r12_load = '1') then
                    m1_bit_sel <= m_cont_out; 
                end if;
            end if;
        end process;
    
    o_bit_count <= m1_bit_sel;

    uk0 <= '0' when m_reset_sel = '0' else m1_out;
          
    p1k <= uk0 xor uk2;
    p2k <= uk0 xor uk1 xor uk2;
    yk <= p1k & p2k;


    m_cont_in <= m1_bit_sel + 1;
    
    count_inp_add: process(i_clk, i_rst)
            begin
                if i_clk'event and i_clk = '1' then
                    m_cont_inp_in <= inp_add + "0000000000000001"; 
                end if;
            end process;
            

    m_inp_cont_out <= (others => '0') when m_inp_add_sel = '0' else m_cont_inp_in;
        
               
     count_outp_add: process(i_clk, i_rst)
               begin
                   if i_clk'event and i_clk = '1' then
                       m_cont_outp_in <= outp_add + "0000000000000001";    
                   end if;
               end process; 
                
    m_outp_cont_out <= "0000001111101000" when m_outp_add_sel = '0' else m_cont_outp_in;

end behavioural;
