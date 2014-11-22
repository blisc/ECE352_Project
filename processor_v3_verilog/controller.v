module controller(
reset, IR, IR3, IR4, clock,
N, Z,
PCwrite, PCSel, MemRead,
MemWrite, IRload, IR3load, IR4load, 
R1Sel, RegWriteWire,
R1R2Load, ALU1, ALU2, ALU3, ALUop,
WBWrite, RFWrite, FlagWrite, IncCount//, state
);
	input	[7:0] IR, IR3, IR4;
	input	N, Z;
	input	reset, clock;
	output	PCwrite, MemRead, PCSel, MemWrite, IRload, R1Sel;
	output	IR3load, IR4load, WBWrite;
	output	R1R2Load, ALU1, ALU3, RFWrite, FlagWrite;
	output	IncCount; //Counter increment
	output   [1:0] RegWriteWire;
	output	[2:0] ALU2, ALUop;
	//output	[3:0] state;
	
	reg	PCwrite, PCSel, MemRead, MemWrite, IRload, IR3load, IR4load, R1Sel;
	reg	R1R2Load, ALU1, ALU3, WBWrite, RFWrite, FlagWrite;
	reg	IncCount; //Counter increment registerization
	reg	[1:0] RegWriteWire;
	reg	[2:0] ALU2, ALUop;
	
	wire [3:0] inst1, inst3, inst4;
	
	assign inst1 = IR[3:0];
	assign inst3 = IR3[3:0];
	assign inst4 = IR4[3:0];
	
	always @(*) 
	begin
		case(inst1)
			4'b0111:
			begin
				R1Sel = 1;
				R1R2Load = 1;
				PCwrite = 1;
				IncCount = 1;
				IRload = 1;
				IR3load = 1;
				IR4load = 1;
			end
			4'b1111:
			begin
				R1Sel = 1;
				R1R2Load = 1;
				PCwrite = 1;
				IncCount = 1;
				IRload = 1;
				IR3load = 1;
				IR4load = 1;
				end
			4'b0001: //STOP
			begin
				PCwrite = 0;			//Dun know
				IncCount = 0;
				IRload = 0;
				IR3load = 0;
				IR4load = 0;
				end
			default:
			begin
				R1Sel = 0;
				R1R2Load = 1;
				PCwrite = 1;
				IncCount = 1;
				IRload = 1;
				IR3load = 1;
				IR4load = 1;
				end
		endcase
		case(inst3)
			4'b0000: //load
			begin
				ALU3 = 1;
				MemRead = 1;
				FlagWrite = 0;
				WBWrite = 1;
				PCSel = 1;
				end
			4'b0010: //store
			begin
				MemWrite = 1;
				FlagWrite = 0;
				PCSel = 1;
				end
			4'b0100: //add
			begin
				ALU1 = 1;
				ALU2 = 3'b000;
				ALU3 = 0;
				ALUop = 3'b000;
				FlagWrite = 1;
				WBWrite = 1;
				MemWrite = 0;
				PCSel = 1;
				end
			4'b0110: //sub
			begin
				ALU1 = 1;
				ALU2 = 3'b000;
				ALU3 = 0;
				ALUop = 3'b001;
				FlagWrite = 1;
				WBWrite = 1;
				MemWrite = 0;
				PCSel = 1;
				end
			4'b1000: //nand
			begin
				ALU1 = 1;
				ALU2 = 3'b000;
				ALU3 = 0;
				ALUop = 3'b011;
				FlagWrite = 1;
				WBWrite = 1;
				MemWrite = 0;
				PCSel = 1;
				end
			4'b0111: //ori
			begin
				ALU1 = 1;
				ALU2 = 3'b011;
				ALU3 = 0;
				ALUop = 3'b010;
				FlagWrite = 1;
				WBWrite = 1;
				MemWrite = 0;
				PCSel = 1;
				end
			4'b1111: //ori
			begin
				ALU1 = 1;
				ALU2 = 3'b011;
				ALU3 = 0;
				ALUop = 3'b010;
				FlagWrite = 1;
				WBWrite = 1;
				MemWrite = 0;
				PCSel = 1;
				end
			4'b0011: //shift
			begin
				MemWrite = 0;
				ALU1 = 1;
				ALU2 = 3'b100;
				ALUop = 3'b100;
				FlagWrite = 1;
				ALU3 = 0;
				WBWrite = 1;
				PCSel = 1;
				end
			4'b1011: //shift
			begin
				MemWrite = 0;
				ALU1 = 1;
				ALU2 = 3'b100;
				ALUop = 3'b100;
				FlagWrite = 1;
				ALU3 = 0;
				WBWrite = 1;
				PCSel = 1;
				end
			4'b0101: //BZ
			begin
				PCSel = ~Z;
				ALU1 = 0;
				ALU2 = 3'b010;
				ALUop = 3'b000;
				FlagWrite = 0;
				WBWrite = 0;
				MemWrite = 0;
				end
			4'b1001: //BNZ
			begin
				PCSel = Z;
				ALU1 = 0;
				ALU2 = 3'b010;
				ALUop = 3'b000;
				FlagWrite = 0;
				WBWrite = 0;
				MemWrite = 0;
				end
			4'b1101: //BPZ
			begin
				PCSel = N;
				ALU1 = 0;
				ALU2 = 3'b010;
				ALUop = 3'b000;
				FlagWrite = 0;
				WBWrite = 0;
				MemWrite = 0;
				end
			default: //nop
			begin
				PCSel = 1;
				FlagWrite = 0;
				WBWrite = 0;
				MemWrite = 0;
				ALU3 = 0;
				end
		endcase
		case(inst4)
			4'b0000:
			begin
				RegWriteWire = IR4[7:6];
				RFWrite = 1;
				end
			4'b0100:
			begin
				RegWriteWire = IR4[7:6];
				RFWrite = 1;
				end
			4'b0110:
			begin
				RegWriteWire = IR4[7:6];
				RFWrite = 1;
				end
			4'b1000:
			begin
				RegWriteWire = IR4[7:6];
				RFWrite = 1;
				end
			4'b0011:
			begin
				RegWriteWire = IR4[7:6];
				RFWrite = 1;
				end
			4'b1011:
			begin
				RegWriteWire = IR4[7:6];
				RFWrite = 1;
				end
			4'b0111: //ori - special
			begin
				RegWriteWire = 2'b01;
				RFWrite = 1;
				end
			4'b1111: //ori - special
			begin
				RegWriteWire = 2'b01;
				RFWrite = 1;
				end
			default: //do not write back
				RFWrite = 0;
		endcase
	end
endmodule
//PCwrite, PCsel, MemRead,
//MemWrite, IRload, IR3load, IR4load, 
//R1Sel,
//R1R2Load, ALU1, ALU2, ALU3, ALUop,
//WBWrite, RFWrite, FlagWrite, IncCount//, state