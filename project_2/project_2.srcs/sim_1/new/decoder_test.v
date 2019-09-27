`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.09.2019 17:10:31
// Design Name: 
// Module Name: decoder_test
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


module decoder_test;
    
reg [3:0] Rd = 0;
reg [1:0] Op = 0;
reg [5:0] Funct = 0;
wire PCS;
wire RegW;
wire MemW;
wire MemtoReg;
wire ALUSrc;
wire [1:0] ImmSrc;
wire [1:0] RegSrc;
wire NoWrite;
wire [1:0] ALUControl;
wire [1:0] FlagW;

Decoder uut(Rd,Op,Funct,Pcs,RegW,MemW,MemtoReg,ALUSrc,ImmSrc,RegSrc,NoWrite,ALUControl,FlagW);

initial begin
Op = 2'b00;
Funct = 6'b100100;
Rd = 4'b0010;
end
endmodule
