LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY control_l IS 
	PORT (ir		: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			op		: OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
			ldpc	: OUT	STD_LOGIC;
			wrd		: OUT	STD_LOGIC;
			addr_a	: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b	: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d	: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			immed	: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			wr_m : OUT STD_LOGIC;
			in_d : OUT STD_LOGIC;
			immed_x2 : OUT STD_LOGIC;
			word_byte : OUT STD_LOGIC);
END control_l;


ARCHITECTURE Structure OF control_l IS
BEGIN
		-- Aqui iria la generacion de las senales de control del datapath

		


	
		WITH ir SELECT
			ldpc <= '0' WHEN "1111111111111111",
			        '1' WHEN others;

		WITH ir(15 DOWNTO 12) SELECT
			op <= '0' & ir(8) WHEN "0101",
					"10" WHEN "0011",
					"10" WHEN "0100",
					"10" WHEN "1101",
					"10" WHEN others; --1110
					
		--Se podria hacer con WITH SELECT, pero sale multiplexor
		WITH ir(15 DOWNTO 12) SELECT
			wrd <= '1' WHEN "0101",
					'1' WHEN "0011",
					'1' WHEN "1101",
					'0' WHEN others;
		
		WITH ir(15 DOWNTO 12) SELECT
			wr_m <= '1' WHEN "0100",
					  '1' WHEN "1110",
					  '0' WHEN others;
					  
		--ra
		WITH ir(15 DOWNTO 12) SELECT
			addr_a <= ir(11 DOWNTO 9) WHEN "0101",
						 ir(8 DOWNTO 6) WHEN "0011",
						 ir(8 DOWNTO 6) WHEN "0100",
						 ir(8 DOWNTO 6) WHEN "1101",
						 ir(8 DOWNTO 6) WHEN others; --1110
 						
			
		--rb
		WITH ir(15 DOWNTO 12) SELECT
			addr_b <= ir(11 DOWNTO 9) WHEN "0100",
						 ir(11 DOWNTO 9) WHEN others; --1100
		
		--rd 
		WITH ir(15 DOWNTO 12) SELECT
			addr_d <= ir(11 DOWNTO 9) WHEN "0101",			 
						 ir(11 DOWNTO 9) WHEN "0011",
						 ir(11 DOWNTO 9) WHEN others; --1101
						 
						 
		--immediato
		WITH ir(15 DOWNTO 12) SELECT
			immed <= std_logic_vector(resize(signed(ir(7 DOWNTO 0)),immed'length)) WHEN "0101",
						std_logic_vector(resize(signed(ir(5 DOWNTO 0)),immed'length)) WHEN others;
						
		--in_d
		WITH ir(15 DOWNTO 12) SELECT
			in_d <= '1' WHEN "0011",
					  '1' WHEN "1101",
					  '0' WHEN others;
					  
		--immed_x2
		WITH ir(15 DOWNTO 12) SELECT
			immed_x2 <= '1' WHEN "0011",
							'1' WHEN "0100",
							'0' WHEN others;
							
		--word_byte
		--negar immed_x2?
		WITH ir(15 DOWNTO 12) SELECT
			word_byte <= '1' WHEN "1101",
							 '1' WHEN "1110",
							 '0' WHEN others;
END Structure;