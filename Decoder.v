`timescale 1ns / 1ps
/*
----------------------------------------------------------------------------------
-- Company: NUS	
-- Engineer: (c) Shahzor Ahmad and Rajesh Panicker  
-- 
-- Create Date: 09/23/2015 06:49:10 PM
-- Module Name: Decoder
-- Project Name: CG3207 Project
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool Versions: Vivado 2015.2
-- Description: Decoder Module
-- 
-- Dependencies: NIL
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
--	License terms :
--	You are free to use this code as long as you
--		(i) DO NOT post it on any public repository;
--		(ii) use it only for educational purposes;
--		(iii) accept the responsibility to ensure that your implementation does not violate any intellectual property of ARM Holdings or other entities.
--		(iv) accept that the program is provided "as is" without warranty of any kind or assurance regarding its suitability for any particular purpose;
--		(v)	acknowledge that the program was written based on the microarchitecture described in the book Digital Design and Computer Architecture, ARM Edition by Harris and Harris;
--		(vi) send an email to rajesh.panicker@ieee.org briefly mentioning its use (except when used for the course CG3207 at the National University of Singapore);
--		(vii) retain this notice in this file or any files derived from this.
----------------------------------------------------------------------------------
*/

module Decoder(
    input [3:0] Rd,
    input [1:0] Op,
    input [5:0] Funct,
    output PCS,
    output RegW,
    output MemW,
    output MemtoReg,
    output ALUSrc,
    output [1:0] ImmSrc,
    output [1:0] RegSrc,
    output NoWrite,
    output [1:0] ALUControl,
    output [1:0] FlagW
    );
    
    wire ALUOp;
    wire Branch;
    reg [9:0] controls;
    reg [3:0] ALUDecoderOutput;
    
    //Main Decoder determines which type of Instruction (refer to truth table)
    always@(*)
    begin
        case(Op)
            2'b00: if(~Funct[5])    controls = 10'b0000001001;  //DP (register)
                   else             controls = 10'b0001001001;  //DP (imm)
            2'b01: if(~Funct[0])    controls = 10'b0011010100;  //Memory (STR)
                   else             controls = 10'b0101011000;  //Memory (LDR)
            2'b10:                  controls = 10'b1001100010;  //Branch
            default:                controls = 10'bx;
        endcase   
    end
    
    assign {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp} = controls;
    
    
    
    //ALU Decoder determines which DP instruction (refer to truth table)
    always@(*) if(ALUOp)
    begin
        case(Funct[4:0])
            5'b01000:               ALUDecoderOutput = 4'b0000;     //ADD   FlagW = 00
            5'b01001:               ALUDecoderOutput = 4'b0011;     //      FlagW = 11
            5'b00100:               ALUDecoderOutput = 4'b0100;     //SUB   FlagW = 00
            5'b00101:               ALUDecoderOutput = 4'b0111;     //      FlagW = 11
            5'b00000:               ALUDecoderOutput = 4'b1000;     //AND   FlagW = 00
            5'b00001:               ALUDecoderOutput = 4'b1010;     //      FlagW = 10
            5'b11000:               ALUDecoderOutput = 4'b1100;     //ORR   FlagW = 00
            5'b11001:               ALUDecoderOutput = 4'b1110;     //      FlagW = 10  
            default:                ALUDecoderOutput = 4'bx;      
        endcase  
    end   
    
    assign {ALUControl, FlagW}  =   ALUDecoderOutput;
    
        
    //PC Logic check if instruction writes to R15, OR if it's a Branch
    assign PCS = ( (Rd == 4'b1111) & RegW ) | Branch;        
    
endmodule





