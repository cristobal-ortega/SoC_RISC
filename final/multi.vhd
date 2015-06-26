LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY multi IS
	PORT(
			clk : IN STD_LOGIC;
			boot : IN STD_LOGIC;
			ldpc_l : IN STD_LOGIC;
			wrd_l : IN STD_LOGIC :='0';
			wr_m_l : IN STD_LOGIC :='0';
			w_b	: IN STD_LOGIC;
			ldpc 	: OUT STD_LOGIC;
			wrd	: OUT STD_LOGIC :='0';
			wr_m	: OUT STD_LOGIC :='0';
			ldir	: OUT STD_LOGIC;
			ins_dad : OUT STD_LOGIC;
			word_byte : OUT STD_LOGIC);
			
END multi;

ARCHITECTURE Structure OF multi IS
	type state_type is(F, DEMW,NB);
	
	SIGNAL estado_actual : state_type :=NB;

BEGIN

	PROCESS(clk,boot)
	BEGIN
		IF boot = '1' THEN
			estado_actual <= F;
		ELSIF rising_edge(clk) THEN
				case estado_actual is
					when F =>
							estado_actual <= DEMW;
					when DEMW =>
							estado_actual <= F;
					when NB =>
							estado_actual <= NB;
				end case;
		END IF;
	
	
	END PROCESS;

	ldpc <= ldpc_l WHEN estado_actual = DEMW else
				'0';
				
	wrd <= wrd_l WHEN estado_actual = DEMW else
				'0';
	
	wr_m <= wr_m_l WHEN estado_actual = DEMW else
				'0';
				
	word_byte <= w_b WHEN estado_actual = DEMW else
					'0';
					
	ins_dad <= '1' WHEN estado_actual = DEMW else
					'0';
	ldir <= '1' WHEN estado_actual = F else
				'0';
				
	
END Structure;