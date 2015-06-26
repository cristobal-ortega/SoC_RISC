LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


ENTITY sisa IS 
	PORT (CLOCK_50		: IN	STD_LOGIC;
			SRAM_ADDR 	: out std_logic_vector(17 downto 0);
			SRAM_DQ 		: inout std_logic_vector(15 downto 0);
			SRAM_UB_N 	: out std_logic;
			SRAM_LB_N 	: out std_logic;
			SRAM_CE_N 	: out std_logic := '1';
			SRAM_OE_N 	: out std_logic := '1';
			SRAM_WE_N 	: out std_logic := '1';							
			KEY : in std_logic_vector(0 downto 0)
			);
END sisa;

ARCHITECTURE Structure OF sisa IS

	COMPONENT proc IS 
	PORT (	boot		: IN	STD_LOGIC;
			clk		: IN	STD_LOGIC;
			datard_m	: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			addr_m	: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			data_wr	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			wr_m	: OUT STD_LOGIC;
			word_byte : OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT MemoryController is 
	port (addr       	: in  std_logic_vector(15 downto 0);
			wr_data     : in  std_logic_vector(15 downto 0);
			rd_data     : out std_logic_vector(15 downto 0);
			we          : in  std_logic;
			byte_m      : in  std_logic;
			CLOCK_50    : in  std_logic;
			SRAM_ADDR 	: out std_logic_vector(17 downto 0);
			SRAM_DQ 		: inout std_logic_vector(15 downto 0);
			SRAM_UB_N 	: out std_logic;
			SRAM_LB_N 	: out std_logic;
			SRAM_CE_N 	: out std_logic := '1';
			SRAM_OE_N 	: out std_logic := '1';
			SRAM_WE_N 	: out std_logic := '1'
			);
	END COMPONENT;	
		
	SIGNAL word_byte_bus :STD_LOGIC;
	SIGNAL wr_bus : STD_LOGIC;
	SIGNAL data_wr_mem : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL addr_mem_bus : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL datard_m_bus : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	SIGNAL reset : STD_LOGIC;
	SIGNAL clk_counter : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	SIGNAL clk : STD_LOGIC := '1';
		
BEGIN		
	
	PROCESS(CLOCK_50)
	BEGIN
		IF KEY = 1 THEN
			reset <= '1';
		ELSE
			reset <= '0';
		END IF;

		
		IF rising_edge(CLOCK_50) THEN
			clk_counter <= clk_counter + "001";
			IF clk_counter = 7 THEN
				clk <= not clk;
			END IF;
		END IF;	
	

	END PROCESS;
	
	
	mem0 : MemoryController
	Port Map( 
			addr => addr_mem_bus,
			wr_data => data_wr_mem,
			rd_data  => datard_m_bus,
			we  => wr_bus,
			byte_m   => word_byte_bus,
			CLOCK_50  => CLOCK_50,
			SRAM_ADDR 	=> SRAM_ADDR,
			SRAM_DQ 	=> SRAM_DQ,
			SRAM_UB_N 	=> SRAM_UB_N,
			SRAM_LB_N 	=> SRAM_LB_N,
			SRAM_CE_N 	=> SRAM_CE_N,
			SRAM_OE_N 	=> SRAM_OE_N,
			SRAM_WE_N 	=> SRAM_WE_N
	);


	proc0 : proc
	PORT MAP(
			boot	=> reset,
			clk	=> clk,
			datard_m => datard_m_bus,
			addr_m	=> addr_mem_bus,
			data_wr	=> data_wr_mem,
			wr_m	=> wr_bus,
			word_byte =>word_byte_bus
	);




END Structure;