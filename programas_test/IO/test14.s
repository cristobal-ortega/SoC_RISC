.text
main:

main:
	MOVI R0, 0X55
	MOVI R2, 0X10
	MOVHI R2, 0x32
	MOVI R3, 0x0F
	MOVI R4,0x00
	OUT 5, R0
	IN R1, 5
	ADD R1,R1,R1
	OUT 6,R1
	OUT 7,R2
	OUT 8,R2
	OUT 10,R2
	OUT 9, R3
	IN R3,7
	ST 0(R4),R3
	IN R3,8
	ST 2(R4),R3
	HALT