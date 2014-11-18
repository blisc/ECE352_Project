module controller(
reset, IR, IR3, IR4, clock,
N, Z,
PCwrite, PCsel, MemRead,
MemWrite, IRload, IR3load, IR4load, 
R1Sel, RegWriteWire,
R1R2Load, ALU1, ALU2, ALU3, ALUop,
WBWrite, RFWrite, FlagWrite, IncCount//, state
);
	input	[7:0] IR, IR3, IR4;
	input	N, Z;
	input	reset, clock;
	output	PCwrite, MemRead, PCsel, MemWrite, IRload, R1Sel;
	output	IR3load, IR4load, WBWrite, RegWriteWire;
	output	R1R2Load, ALU1, ALU3, RFWrite, FlagWrite;
	output	IncCount; //Counter increment
	output	[2:0] ALU2, ALUop;
	//output	[3:0] state;
	
	reg	PCwrite, PCsel, MemRead, MemWrite, IRload, IR3load, IR4load, R1Sel;
	reg	R1R2Load, ALU1, ALU3, WBWrite, RFWrite, FlagWrite, RegWriteWire;
	reg	IncCount; //Counter increment registerization
	reg	[2:0] ALU2, ALUop;
	
	wire [3:0] inst1, inst3, inst4;
	
	assign inst1 = IR[3:0];
	assign inst3 = IR3[3:0];
	assign inst4 = IR4[3:0];
	
	always @(*) 
	begin
		case(inst1)
			4b'Z111:
				R1Sel = 1;
				R1R2Load = 1;
				IR3load = 1;
				PCwrite = 1;
			4b'0001: //STOP
				PCWrite = 0;
				IR3load = 0;			//Dun know
				incCount = 0;
			default:
				R1Sel = 0;
				R1R2Load = 1;
				IR3load = 1;
				PCwrite = 1;
		endcase
		case(inst3)
			4'b0000: //load
				ALU3 = 1;
				MemRead = 1;
				FlagWrite = 0;
				WBWrite = 1;
				IR4load = 1;
				PCSel = 1;
			4'b0010: //store
				MemWrite = 1;
				FlagWrite = 0;
				IR4load = 1;
				PCSel = 1;
			4'b0100: //add
				ALU1 = 1;
				ALU2 = 3'b000;
				ALU3 = 0;
				ALUop = 3'b000;
				FlagWrite = 1;
				WBWrite = 1;
				IR4load = 1;
				MemWrite = 0;
				PCSel = 1;
			4'b0110: //sub
				ALU1 = 1;
				ALU2 = 3'b000;
				ALU3 = 0;
				ALUop = 3'b001;
				FlagWrite = 1;
				WBWrite = 1;
				IR4load = 1;
				MemWrite = 0;
				PCSel = 1;
			4'b1000: //nand
				ALU1 = 1;
				ALU2 = 3'b000;
				ALU3 = 0;
				ALUop = 3'b011;
				FlagWrite = 1;
				WBWrite = 1;
				IR4load = 1;
				MemWrite = 0;
				PCSel = 1;
			4'bZ111: //ori
				ALU1 = 1;
				ALU2 = 3'b011;
				ALU3 = 0;
				ALUop = 3'b010;
				FlagWrite = 1;
				WBWrite = 1;
				IR4load = 1;
				MemWrite = 0;
				PCSel = 1;
			4'bZ011: //shift
				MemWrite = 0;
				IR4load = 1;
				ALU1 = 1;
				ALU2 = 3'b100;
				ALUop = 3'b100;
				FlagWrite = 1;
				ALU3 = 0;
				WBWrite = 1;
				PCSel = 1;
			4'b0101: //BZ
				PCSel = ~Z;
				IR4load = 1;
				ALU1 = 0;
				ALU2 = 3'b010;
				ALUop = 3'b000;
				FlagWrite = 0;
				WBWrite = 0;
				MemWrite = 0;
			4'b1001: //BNZ
				PCSel = Z;
				IR4load = 1;
				ALU1 = 0;
				ALU2 = 3'b010;
				ALUop = 3'b000;
				FlagWrite = 0;
				WBWrite = 0;
				MemWrite = 0;
			4'b1101: //BPZ
				PCSel = N;
				IR4load = 1;
				ALU1 = 0;
				ALU2 = 3'b010;
				ALUop = 3'b000;
				FlagWrite = 0;
				WBWrite = 0;
				MemWrite = 0;
			default: //nop
				IR4load = 1;
				PCSel = 1;
				FlagWrite = 0;
				WBWrite = 0;
				MemWrite = 0;
		endcase
		case(inst4)
			4'b0000:
				RegWriteWire = IR4[7:6];
				RFWrite = 1;
			4'b0100:
				RegWriteWire = IR4[7:6];
				RFWrite = 1;
			4'b0110:
				RegWriteWire = IR4[7:6];
				RFWrite = 1;
			4'b1000:
				RegWriteWire = IR4[7:6];
				RFWrite = 1;
			4'bZ011:
				RegWriteWire = IR4[7:6];
				RFWrite = 1;
			4'bZ111: //ori - special
				RegWriteWire = 2'b01;
				RFWrite = 1;
			default: //do not write back
				RFWrite = 0;
		endcase
	end
	
//PCwrite, PCsel, MemRead,
//MemWrite, IRload, IR3load, IR4load, 
//R1Sel,
//R1R2Load, ALU1, ALU2, ALU3, ALUop,
//WBWrite, RFWrite, FlagWrite, IncCount//, state