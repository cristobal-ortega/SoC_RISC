LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

ENTITY datapath IS 
	PORT (clk		: IN	STD_LOGIC;
			op		: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			wrd		: IN	STD_LOGIC;
			addr_a	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
			immed	: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			immed_x2 : IN STD_LOGIC;
			datard_m : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			ins_dad  : IN STD_LOGIC;
			pc			: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			in_d		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			Rb_N : IN STD_LOGIC;
			f : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_m	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			data_wr	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			z			: OUT STD_LOGIC;
			w			: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0)
			);
END datapath;


ARCHITECTURE Structure OF datapath IS

	COMPONENT alu IS
	PORT (x 			: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			y 			: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			op			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			f			: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
			w			: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			z			: OUT	STD_LOGIC
			);
	END COMPONENT;

	COMPONENT regfile IS
	PORT (clk		: IN	STD_LOGIC;
			wrd		: IN	STD_LOGIC;
			d 		: IN 	STD_LOGIC_VECTOR(15 DOWNTO 0);
			addr_a	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
			a		: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			b		: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	
	SIGNAL ra :	STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL rb : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL y_bus : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL rd : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL rd_alu : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL immed_final : STD_LOGIC_VECTOR(15 DOWNTO 0);
	-- Aqui iria la declaracion de las entidades que vamos a usar 
	-- Usaremos la palabra reservada COMPONENT ...
	-- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
	
BEGIN
		alu0 : alu
		Port Map( 	x => ra,
						y => y_bus,
						op => op,
						f => f,
						w => rd_alu,
						z => z
					);
					
					
					
		regfile0 : regfile
		Port Map( 	clk => clk,
						wrd => wrd,
						d => rd,
						addr_a => addr_a,
						addr_b => addr_b,
						addr_d => addr_d,
						a => ra,
						b => rb
					);
		
		w <= rd_alu;
		
		WITH Rb_N SELECT
			y_bus <= rb WHEN '0',
						immed_final WHEN others;
		
		WITH in_d SELECT
			rd <= rd_alu WHEN "00",
					datard_m WHEN "01",
					pc + 2 WHEN others;
					
		WITH immed_x2 SELECT
			immed_final <= immed WHEN '0',
								immed(14 DOWNTO 0) & '0' WHEN others;
								
		WITH ins_dad SELECT
			addr_m <= pc WHEN '0',
						 rd_alu WHEN others;

		--salida a memoria, stores
		data_wr <= rb;
		
END Structure;