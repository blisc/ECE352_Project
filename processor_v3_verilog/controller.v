module controller(
reset, IR, IR3, IR4, clock,
N, Z,
PCwrite, PCsel, MemRead,
MemWrite, IRload, IR3load, IR4load, 
R1Sel,
R1R2Load, ALU1, ALU2, ALU3, ALUop,
WBWrite, RFWrite, FlagWrite, IncCount//, state
);
	input	[7:0] IR, IR3, IR4;
	input	N, Z;
	input	reset, clock;
	output	PCwrite, MemRead, PCsel, MemWrite, IRload, R1Sel;
	output	IR3load, IR4load, WBWrite;
	output	R1R2Load, ALU1, ALU3, RFWrite, FlagWrite;
	output	IncCount; //Counter increment
	output	[2:0] ALU2, ALUop;
	//output	[3:0] state;
	
	reg	PCwrite, PCsel, MemRead, MemWrite, IRload, IR3load, IR4load, R1Sel;
	reg	R1R2Load, ALU1, ALU3, WBWrite, RFWrite, FlagWrite;
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
			4b'0001:
				PCWrite = 0;
				IR3load = 0;			//Dun know
				incCount = 0;
			default:
				R1Sel = 0;
				R1R2Load = 1;
				IR3load = 1;
		endcase
		case(inst3)
			4'b
		endcase
	end
	
//PCwrite, PCsel, MemRead,
//MemWrite, IRload, IR3load, IR4load, 
//R1Sel,
//R1R2Load, ALU1, ALU2, ALU3, ALUop,
//WBWrite, RFWrite, FlagWrite, IncCount//, state