`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/05/13 23:49:33
// Design Name:
// Module Name: control32
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module control32(Opcode, Function_opcode, Jr, RegDST, ALUSrc, MemorIOtoReg, RegWrite, MemRead, MemWrite, IORead, IOWrite, Branch, nBranch, Jmp, Jal, I_format, Sftmd, ALUOp, AlU_resultHigh);
input[5: 0] Opcode;            // ����IFetchģ���ָ���6bit
input[5: 0] Function_opcode;  	// ����IFetchģ���ָ���6bit����������r-�����е�ָ��
output Jr;         	 // Ϊ1������ǰָ����jr��Ϊ0��ʾ��ǰָ���jr
output RegDST;          // Ϊ1����Ŀ�ļĴ�����rd��Ϊ0ʱ��ʾĿ�ļĴ�����rt
output ALUSrc;          // Ϊ1�����ڶ�����������ALU�е�Binput��������������beq��bne���⣩��Ϊ0ʱ��ʾ�ڶ������������ԼĴ���
output MemorIOtoReg;     // Ϊ1�����Ӵ洢����I/O��ȡ����д���Ĵ�����Ϊ0ʱ��ʾ��ALUģ���������д���Ĵ���
output RegWrite;   	  // Ϊ1������ָ����Ҫд�Ĵ�����Ϊ0ʱ��ʾ����Ҫд�Ĵ���
output MemRead; //1 indicates that the instruction needs to read from the memory
output MemWrite;       // Ϊ1������ָ����Ҫд�洢����Ϊ0ʱ��ʾ����Ҫд������
output IORead; // 1 indicates  I/O read
output IOWrite; // 1 indicates  I/O write

output Branch;        // Ϊ1������beqָ�Ϊ0ʱ��ʾ����beqָ��
output nBranch;       // Ϊ1������bneָ�Ϊ0ʱ��ʾ����bneָ��
output Jmp;            // Ϊ1������jָ�Ϊ0ʱ��ʾ����jָ��
output Jal;            // Ϊ1������jalָ�Ϊ0ʱ��ʾ����jalָ��
output I_format;      // Ϊ1������ָ���ǳ�beq��bne��lw��sw֮���I-����ָ��������Ϊ0
output Sftmd;         // Ϊ1��������λָ�Ϊ0����������λָ��
output[1: 0] ALUOp;        // ��ָ��ΪR-type��I_formatΪ1ʱ��ALUOp�ĸ߱���λΪ1������߱���λΪ0; ��ָ��Ϊbeq��bneʱ��ALUOp�ĵͱ���λΪ1������ͱ���λΪ0
input[21: 0] AlU_resultHigh;  // From the execution unit Alu_Result[31..10]

wire R_format;
wire Lw;
wire Sw;

assign R_format = (Opcode == 6'b000000) ? 1'b1 : 1'b0;
assign Lw = (Opcode == 6'b100011) ? 1'b1 : 1'b0;
assign Sw = (Opcode == 6'b101011) ? 1'b1 : 1'b0;

assign Jr = ((R_format) && (Function_opcode == 6'b001000)) ? 1'b1 : 1'b0;
assign RegDST = R_format;
assign ALUSrc = (I_format || Lw || Sw);
assign MemorIOtoReg = IORead || MemRead;
assign RegWrite = (R_format || Lw || Jal || I_format) && !(Jr);
assign MemWrite = ((Sw==1) && (AlU_resultHigh[21:0] != 22'h3FFFFF)) ? 1'b1:1'b0; 
assign MemRead =((Lw==1) && (AlU_resultHigh[21:0] != 22'h3FFFFF)) ? 1'b1:1'b0;
assign IORead=((Lw==1) && (AlU_resultHigh[21:0] == 22'h3FFFFF)) ? 1'b1:1'b0;
assign IOWrite= ((Sw==1) && (AlU_resultHigh[21:0] == 22'h3FFFFF)) ? 1'b1:1'b0; 
assign Branch = (Opcode == 6'b000100) ? 1'b1 : 1'b0;
assign nBranch = (Opcode == 6'b000101) ? 1'b1 : 1'b0;
assign Jmp = (Opcode == 6'b000010) ? 1'b1 : 1'b0;
assign Jal = (Opcode == 6'b000011) ? 1'b1 : 1'b0;
assign I_format = (Opcode[5: 3] == 3'b001) ? 1'b1 : 1'b0;
assign Sftmd = (((Function_opcode == 6'b000000) || (Function_opcode == 6'b000010) || (Function_opcode == 6'b000011) || (Function_opcode == 6'b000100) || (Function_opcode == 6'b000110) || (Function_opcode == 6'b000111)) && R_format) ? 1'b1 : 1'b0;
assign ALUOp = { (R_format || I_format) , (Branch || nBranch) };

endmodule