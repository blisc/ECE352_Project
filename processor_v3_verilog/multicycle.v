// ---------------------------------------------------------------------
// Copyright (c) 2007 by University of Toronto ECE 243 development team 
// ---------------------------------------------------------------------
//
// Major Functions:	a simple processor which operates basic mathematical
//					operations as follow:
//					(1)loading, (2)storing, (3)adding, (4)subtracting,
//					(5)shifting, (6)oring, (7)branch if zero,
//					(8)branch if not zero, (9)branch if positive zero
//					 
// Input(s):		1. KEY0(reset): clear all values from registers,
//									reset flags condition, and reset
//									control FSM
//					2. KEY1(clock): manual clock controls FSM and all
//									synchronous components at every
//									positive clock edge
//
//
// Output(s):		1. HEX Display: display registers value K3 to K1
//									in hexadecimal format
//
//					** For more details, please refer to the document
//					   provided with this implementation
//
// ---------------------------------------------------------------------

module multicycle
(
SW, KEY, HEX0, HEX1, HEX2, HEX3,
HEX4, HEX5, HEX6, HEX7, LEDG, LEDR
);

// ------------------------ PORT declaration ------------------------ //
input	[1:0] KEY;
input [2:0] SW;
output	[6:0] HEX0, HEX1, HEX2, HEX3;
output	[6:0] HEX4, HEX5, HEX6, HEX7;
output	[7:0] LEDG;
output	[17:0] LEDR;

// ------------------------- Registers/Wires ------------------------ //
wire	clock, reset;
wire	IRLoad, MDRLoad, MemRead, MemWrite, PCWrite, RegIn, AddrSel;
wire	ALUOutWrite, FlagWrite, R1R2Load, R1Sel, RFWrite;
wire	[7:0] R2wire, R1wire, RFout1wire, RFout2wire;
wire	[7:0] ALU1wire, ALU2wire, ALUwire, ALUOut, MDRwire, MEMwire;
wire	[7:0] PCwire, INSTRwire;
wire	[7:0] IR, SE4wire, ZE5wire, ZE3wire, RegWire; //, AddrWire
wire	[7:0] reg0, reg1, reg2, reg3;
wire	[7:0] constant;
wire	[2:0] ALUOp, ALU2;
wire	[1:0] R1_in;
wire	Nwire, Zwire;
wire	[15:0] InstrCount;
wire	IncCount;
wire	[7:0] disp0, disp1, disp2, disp3;
reg		N, Z;

//new declared for part 2
wire	[7:0] IR3, IR4, WBwire, PCdat, PC_INCwire, WBin,  PCwire2, PCwire3; 
wire  [1:0] RegWriteWire;
wire  IR3Load, IR4Load, PCSel, ALU3, WBenable, PCWrite2, PCWrite3;

//Data Hazards Addition
wire  [1:0] ALU1;
wire	[7:0] R1wire1, R2wire2, AddrSelect, MemIN;
wire	R1Mux, R2Mux;


// ------------------------ Input Assignment ------------------------ //
assign	clock = KEY[1];
assign	reset =  ~KEY[0]; // KEY is active high


// ------------------- DE2 compatible HEX display ------------------- //
chooseHEXs	Hex_switch(
	.in0(reg3),.in1(reg2),.in2(InstrCount[7:0]),.in3(InstrCount[15:8]),
	.out0(disp0),.out1(disp1),.select(SW[2])
);
HEXs	HEX_display(
	.in0(reg0),.in1(reg1),.in2(disp1),.in3(disp0),
	.out0(HEX0),.out1(HEX1),.out2(HEX2),.out3(HEX3),
	.out4(HEX4),.out5(HEX5),.out6(HEX6),.out7(HEX7)
);
// ----------------- END DE2 compatible HEX display ----------------- //

/*
// ------------------- DE1 compatible HEX display ------------------- //
chooseHEXs	HEX_display(
	.in0(reg0),.in1(reg1),.in2(reg2),.in3(reg3),
	.out0(HEX0),.out1(HEX1),.select(SW[1:0])
);
// turn other HEX display off
assign HEX2 = 7'b1111111;
assign HEX3 = 7'b1111111;
assign HEX4 = 7'b1111111;
assign HEX5 = 7'b1111111;
assign HEX6 = 7'b1111111;
assign HEX7 = 7'b1111111;
// ----------------- END DE1 compatible HEX display ----------------- //
*/

/*FSM		Control(//Need to change a shit ton of shit here now and not FSM anymore
	.reset(reset),.clock(clock),.N(N),.Z(Z),.instr(IR[3:0]),
	.PCwrite(PCWrite),.AddrSel(AddrSel),.MemRead(MemRead),.MemWrite(MemWrite),
	.IRload(IRLoad),.R1Sel(R1Sel),.MDRload(MDRLoad),.R1R2Load(R1R2Load),
	.ALU1(ALU1),.ALUOutWrite(ALUOutWrite),.RFWrite(RFWrite),.RegIn(RegIn),
	.FlagWrite(FlagWrite),.ALU2(ALU2),.ALUop(ALUOp),.IncCount(IncCount)
);*/

//DataHazard Stuff
mux2to1_8bit R1_mux(
	.data0x(WBwire),.data1x(RFout1wire), 
	.sel(R1Mux),.result(R1wire1)					
);

mux2to1_8bit R2_mux(
	.data0x(WBwire),.data1x(RFout2wire), 
	.sel(R2Mux),.result(R2wire2)					
);

mux2to1_8bit Addr_mux(
	.data0x(WBwire),.data1x(R2wire), 
	.sel(AddrMux),.result(AddrSelect)					
);

mux2to1_8bit MemIn_mux(
	.data0x(WBwire),.data1x(R1wire), 
	.sel(MemInMux),.result(MemIN)					
);

//General
controller Control(
	.reset(reset), .clock(clock), .N(N), .Z(Z),
	.IR(IR), .IR3(IR3), .IR4(IR4),
	.PCwrite(PCWrite), .PCSel(PCSel), .MemRead(MemRead), .MemWrite(MemWrite),
	.IRload(IRLoad), .IR3load(IR3Load), .IR4load(IR4Load),
	.R1Sel(R1Sel), .RegWriteWire(RegWriteWire),
	.R1R2Load(R1R2Load), .ALU1(ALU1), .ALU2(ALU2), .ALU3(ALU3), .ALUop(ALUOp),
	.WBWrite(WBenable), .RFWrite(RFWrite), .FlagWrite(FlagWrite), .IncCount(IncCount),
	.PCWrite2(PCWrite2), .PCWrite3(PCWrite3),
	.R1Mux(R1Mux), .R2Mux(R2Mux), .AddrMux(AddrMux), .MemInMux(MemInMux)
);

memory	DataMem(
	.MemRead(MemRead),.wren(MemWrite),.clock(clock),
	.address(AddrSelect),.data(MemIN),.q(MEMwire),.address_pc(PCwire),.q_pc(INSTRwire)
);

ALU		ALU(
	.in1(ALU1wire),.in2(ALU2wire),.out(ALUwire),
	.ALUOp(ALUOp),.N(Nwire),.Z(Zwire)
);

RF		RF_block(
	.clock(clock),.reset(reset),.RFWrite(RFWrite),
	.dataw(WBwire),.reg1(R1_in),.reg2(IR[5:4]),
	.regw(RegWriteWire),.data1(RFout1wire),.data2(RFout2wire), //REMEMBER, Regw and WBWwire needs to be changed
	.r0(reg0),.r1(reg1),.r2(reg2),.r3(reg3)							//RegWriteWire, WBWire declared
);

register_8bit	IR1_reg(
	.clock(clock),.aclr(reset),.enable(IRLoad),
	.data(INSTRwire),.q(IR)
);

//register_8bit	IR2_reg(
//	.clock(clock),.aclr(reset),.enable(IR2Load), //Remember to make new wires for this shit
//	.data(IR),.q(IR2)
//);

register_8bit	IR3_reg(
	.clock(clock),.aclr(reset),.enable(IR3Load), //Remember to make new wires for this shit
	.data(IR),.q(IR3)										//IR3, IR3Load
);

register_8bit	IR4_reg(
	.clock(clock),.aclr(reset),.enable(IR4Load), //Remember to make new wires for this shit
	.data(IR3),.q(IR4)									//IR4, IR4Load
);

//register_8bit	MDR_reg(
//	.clock(clock),.aclr(reset),.enable(MDRLoad),
//	.data(MEMwire),.q(MDRwire)
//);

register_8bit	PC(
	.clock(clock),.aclr(reset),.enable(PCWrite), //Remember some shit over here too
	.data(PCdat),.q(PCwire)								//PCdat
);

register_8bit	PC2(
	.clock(clock),.aclr(reset),.enable(PCWrite2), //Remember some shit over here too
	.data(PCdat),.q(PCwire2)								//PCWrite2, PCwire2
);

register_8bit	PC3(
	.clock(clock),.aclr(reset),.enable(PCWrite3), //Remember some shit over here too
	.data(PCwire2),.q(PCwire3)								//PCWrite3, PCwire3
);

adder PC_inc(
	.A(PCwire),.B(constant),.out(PC_INCwire) //Remember this shit, right here
															//PC_INCwire
);

mux2to1_8bit PC_Sel(
	.data0x(ALUwire),.data1x(PC_INCwire), ///////////////////////
	.sel(PCSel),.result(PCdat)					//PCSel
);

register_8bit	R1(
	.clock(clock),.aclr(reset),.enable(R1R2Load),
	.data(R1wire1),.q(R1wire)
);

register_8bit	R2(
	.clock(clock),.aclr(reset),.enable(R1R2Load),
	.data(R2wire2),.q(R2wire)
);

mux2to1_8bit	ALUOutSel(
	.data0x(ALUwire),.data1x(MEMwire),
	.sel(ALU3),.result(WBin)	//Shit here too motherfucker
										//WBin, ALU3
);

register_8bit	WB_reg(
	.clock(clock),.aclr(reset),.enable(WBenable), //Rem some shit here
	.data(WBin),.q(WBwire)					//WBEnable
);

mux2to1_2bit		R1Sel_mux(
	.data0x(IR[7:6]),.data1x(constant[1:0]),
	.sel(R1Sel),.result(R1_in)
);

//mux2to1_8bit 		AddrSel_mux(
//	.data0x(R2wire),.data1x(PCwire),
//	.sel(AddrSel),.result(AddrWire)
//);

//mux2to1_8bit 		RegMux(
//	.data0x(ALUOut),.data1x(MDRwire),
//	.sel(RegIn),.result(RegWire)
//);

mux3to1_8bit 		ALU1_mux(
	.data0x(PCwire3),.data1x(R1wire), .data2x(WBwire),  //check data0x to reg PC
	.sel(ALU1), .result(ALU1wire)			//done
);

mux5to1_8bit 		ALU2_mux(
	.data0x(R2wire),.data1x(WBwire),.data2x(SE4wire),
	.data3x(ZE5wire),.data4x(ZE3wire),.sel(ALU2),.result(ALU2wire)
);
counter		Cycle_Counter(
	.reset(reset),.clock(clock),.enable(IncCount),.count(InstrCount)
);

sExtend		SE4(.in(IR3[7:4]),.out(SE4wire));
zExtend		ZE3(.in(IR3[5:3]),.out(ZE3wire));
zExtend		ZE5(.in(IR3[7:3]),.out(ZE5wire));
// define parameter for the data size to be extended
defparam	SE4.n = 4;
defparam	ZE3.n = 3;
defparam	ZE5.n = 5;

always@(posedge clock or posedge reset)
begin
if (reset)
	begin
	N <= 0;
	Z <= 0;
	end
else
if (FlagWrite)
	begin
	N <= Nwire;
	Z <= Zwire;
	end
end

// ------------------------ Assign Constant 1 ----------------------- //
assign	constant = 1;

// ------------------------- LEDs Indicator ------------------------- //
assign	LEDR[17] = PCWrite;
assign	LEDR[16] = AddrSel;
assign	LEDR[15] = MemRead;
assign	LEDR[14] = MemWrite;
assign	LEDR[13] = IRLoad;
assign	LEDR[12] = R1Sel;
assign	LEDR[11] = MDRLoad;
assign	LEDR[10] = R1R2Load;
assign	LEDR[9] = ALU1[0];
assign	LEDR[2] = ALUOutWrite;
assign	LEDR[1] = RFWrite;
assign	LEDR[0] = RegIn;
assign	LEDR[8:6] = ALU2[2:0];
assign	LEDR[5:3] = ALUOp[2:0];
assign	LEDG[6:2] = constant[7:3];
assign	LEDG[7] = FlagWrite;
assign	LEDG[1] = N;
assign	LEDG[0] = Z;

endmodule
