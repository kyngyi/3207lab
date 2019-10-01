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
    output reg NoWrite,
    output reg [1:0] ALUControl,
    output reg [1:0] FlagW
    );
    
    wire ALUOp;
    wire Branch;
    reg [9:0] controls;
    
    //Main Decoder determines which type of Instruction (refer to truth table)
    always@(*)
    begin
        case(Op)
            2'b00: if(~Funct[5])    controls = 10'b0000001001;  //DP (register) | ALUOp = 1 (last bit)
                   else             controls = 10'b0001001001;  //DP (imm)      | ALUOp = 1 (last bit)
            2'b01: if(~Funct[0])    controls = 10'b0011010100;  //Memory (STR)
                   else             controls = 10'b0101011000;  //Memory (LDR)
            2'b10:                  controls = 10'b1001100010;  //Branch
            default:                controls = 10'bx;
        endcase   
    end
    
    assign {Branch, MemtoReg, MemW, ALUSrc, ImmSrc, RegW, RegSrc, ALUOp} = controls;
    
    
    //ALU Decoder determines ALUControl (ADD/ SUB/ AND/ ORR), FlagW (NZCV flags) and NoWrite (CMP/ CMN)
    always@(*) 
    if(ALUOp == 1) begin                 //DP instructions: (ALUOP = 1)
        case(Funct[4:1])
            4'b0100:                ALUControl = 2'b00; //ADD
            4'b0010:                ALUControl = 2'b01; //SUB
            4'b0000:                ALUControl = 2'b10; //AND
            4'b1100:                ALUControl = 2'b11; //ORR
            4'b1010:                ALUControl = 2'b01; //CMP (same as SUBS)
            4'b1011:                ALUControl = 2'b00; //CMN (same as ADDS)
        endcase
    
    FlagW[1] <= Funct[0];   //update flags is S-bit (Funct[0]) is set
    FlagW[0] <= Funct[0] & ( ALUControl == 2'b00 | ALUControl == 2'b01);
    
    NoWrite <= ( Funct[4:1]==4'b1010 | Funct[4:1]==4'b1011 );
    end
    
    else begin
        ALUControl = {1'b0, ~Funct[3]}; //Non-dp function ( Add/Sub of imm determined by U bit)
        FlagW = 2'b00;    
        NoWrite = 1'b0;          
    end
      
        
    //PC Logic check if instruction writes to R15, OR if it's a Branch
    assign PCS = ( (Rd == 4'b1111) & RegW ) | Branch;        
    
endmodule





