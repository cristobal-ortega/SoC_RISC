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
			LEDG			: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			LEDR			: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			HEX0			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			HEX1			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			HEX2			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			HEX3			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
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
			addr_io : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			wr_io : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			wr_out : OUT STD_LOGIC;
			rd_in : OUT STD_LOGIC;
			rd_io : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
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
	
	COMPONENT controladores_IO IS
	PORT (boot : IN STD_LOGIC;
		CLOCK_50 : IN std_logic;
		addr_io : IN std_logic_vector(7 downto 0);
		wr_io : in std_logic_vector(15 downto 0);
		rd_io : out std_logic_vector(15 downto 0);
		wr_out : in std_logic;
		rd_in : in std_logic;
		switch		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		pulsadores : IN std_logic_vector(3 downto 0);
		hexa0			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		hexa1			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		hexa2			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		hexa3			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);	
		led_verdes : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		led_rojos : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT; 
		
	SIGNAL word_byte_bus :STD_LOGIC;
	SIGNAL wr_bus : STD_LOGIC;
	SIGNAL data_wr_mem : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL addr_mem_bus : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL datard_m_bus : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	SIGNAL reset : STD_LOGIC;
	SIGNAL clk_counter : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	SIGNAL clk : STD_LOGIC := '1';
	SIGNAL addr_io_bus : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL wr_io_bus : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL wr_out_bus : STD_LOGIC;
	SIGNAL rd_in_bus : STD_LOGIC;
	SIGNAL rd_io_bus : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	SIGNAL pulsadores : STD_LOGIC_VECTOR(3 DOWNTO 0); --DEBUG, QUITAR LUEGO
	SIGNAL switch : STD_LOGIC_VECTOR(7 DOWNTO 0); --DEBUG, QUITAR LUEGO	
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
			addr_io => addr_io_bus,
			wr_io => wr_io_bus,
			wr_out => wr_out_bus,
			rd_in => rd_in_bus,
			rd_io => rd_io_bus,
			word_byte =>word_byte_bus
	);

	cont0 : controladores_IO
	PORT MAP(
		boot => reset,
		CLOCK_50 => CLOCK_50,
		addr_io => addr_io_bus,
		wr_io => wr_io_bus,
		rd_io => rd_io_bus,
		wr_out => wr_out_bus,
		rd_in => rd_in_bus,
		switch => switch,
		pulsadores => pulsadores,
		hexa0 => HEX0,
		hexa1 => HEX1,
		hexa2 => HEX2,
		hexa3 => HEX3,
		led_verdes => LEDG,
		led_rojos => LEDR	
	);



END Structure;