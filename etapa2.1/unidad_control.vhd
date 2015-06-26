LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY unidad_control IS 
	PORT (boot	: IN	STD_LOGIC;
			clk		: IN	STD_LOGIC;
			datard_m	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			op		: OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
			wrd		: OUT	STD_LOGIC;
			addr_a	: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b	: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d	: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			immed	: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			pc		: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			ins_dad	: OUT STD_LOGIC;
			in_d 	: OUT STD_LOGIC;
			immed_x2	: OUT STD_LOGIC;
			wr_m 	: OUT STD_LOGIC;
			word_byte	: OUT STD_LOGIC
			
			);
END unidad_control;

ARCHITECTURE Structure OF unidad_control IS

	-- Aqui iria la declaracion de las entidades que vamos a usar 
	-- Usaremos la palabra reservada COMPONENT ...
	-- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
	-- Aqui iria la definicion del program counter
	
	COMPONENT control_l IS
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
	END COMPONENT;
	
	COMPONENT multi IS
	PORT(clk : IN STD_LOGIC;
			boot : IN STD_LOGIC;
			ldpc_l : IN STD_LOGIC;
			wrd_l : IN STD_LOGIC;
			wr_m_l : IN STD_LOGIC;
			w_b	: IN STD_LOGIC;
			ldpc 	: OUT STD_LOGIC;
			wrd	: OUT STD_LOGIC;
			wr_m	: OUT STD_LOGIC;
			ldir	: OUT STD_LOGIC;
			ins_dad : OUT STD_LOGIC;
			word_byte : OUT STD_LOGIC);
	END COMPONENT;

	SIGNAL ldpc_bus : STD_LOGIC;
	SIGNAL ldpc : STD_LOGIC;
	SIGNAL new_pc : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ir	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL wr_m_bus : STD_LOGIC;
	SIGNAL word_byte_bus : STD_LOGIC;
	SIGNAL wrd_bus : STD_LOGIC;
	SIGNAL ldir : STD_LOGIC;

	
BEGIN
		
	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia de la logica de control le hemos llamado c0
	
	-- Aqui iria la definicion del comportamiento de la unidad de control y la gestion del PC

	PROCESS(clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF boot = '1' THEN
				new_pc <= "1100000000000000";
				ir <= "0000000000000000";
			ELSE
				IF(ldpc = '1') THEN
					new_pc <= new_pc + 2;
				END IF;
			END IF;
			IF ldir = '1' THEN
				ir <= datard_m;
			END IF;
		END IF;
	END PROCESS;
	
	

	
				
	PC <= new_pc;
	
	

	control_l0 : control_l
	Port Map( 	ir => ir,
					op => op,
					ldpc => ldpc_bus,
					wrd => wrd_bus,
					addr_a => addr_a,
					addr_b => addr_b,
					addr_d => addr_d,
					immed => immed,
					wr_m => wr_m_bus,
					in_d => in_d,
					immed_x2 => immed_x2,
					word_byte => word_byte_bus
				);
				
				

			
	multi0 : multi
	Port Map( 	clk => clk,
					boot => boot,
					ldpc_l => ldpc_bus,
					wrd_l => wrd_bus,
					wr_m_l => wr_m_bus,
					w_b => word_byte_bus,
					ldpc => ldpc,
					wrd => wrd,
					wr_m => wr_m,
					ldir => ldir,
					ins_dad => ins_dad,
					word_byte => word_byte
				);
	

	
END Structure;