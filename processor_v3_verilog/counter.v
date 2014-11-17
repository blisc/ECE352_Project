module counter(reset, clock, enable, count);
input reset, clock, enable;
output reg [15:0] count;

always @(posedge clock or posedge reset)
begin
	if(reset)
		count <= 16'b0;
	else if(enable)
		count <= count + 1;
end
endmodule
