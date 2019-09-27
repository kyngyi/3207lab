`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.09.2019 18:14:57
// Design Name: 
// Module Name: cond_logic_test
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


module cond_logic_test;

reg CLK = 0;
reg PCS = 0;
reg RegW = 0;
reg NoWrite = 0;
reg MemW = 0;
reg [1:0] FlagW = 2'b00;
reg [3:0] Cond = 4'b0000;
reg [3:0] ALUFlags = 4'b0000;
wire PCSrc;
wire RegWrite;
wire MemWrite;
//wire [3:0] flags;

CondLogic uut(CLK,PCS,RegW,NoWrite,MemW,FlagW,Cond,ALUFlags,PCSrc,RegWrite,MemWrite);
//CondLogic uut(CLK,PCS,RegW,NoWrite,MemW,FlagW,Cond,ALUFlags,PCSrc,RegWrite,MemWrite,flags);

integer i;

initial begin
    #1 Cond = 4'b1110;
    #1 FlagW = 2'b11;
    #1 PCS = 1;
    RegW = 1;
    ALUFlags = 4'b0000; 
    for (i=0;i<100;i=i+1) begin
    #1 CLK = ~CLK;
    end
end

endmodule
