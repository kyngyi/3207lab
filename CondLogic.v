`timescale 1ns / 1ps
/*
----------------------------------------------------------------------------------
-- Company: NUS	
-- Engineer: (c) Shahzor Ahmad and Rajesh Panicker  
-- 
-- Create Date: 09/23/2015 06:49:10 PM
-- Module Name: CondLogic
-- Project Name: CG3207 Project
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool Versions: Vivado 2015.2
-- Description: CondLogic Module
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

module CondLogic(
    input CLK,
    input PCS,
    input RegW,
    input NoWrite,
    input MemW,
    input [1:0] FlagW,
    input [3:0] Cond,
    input [3:0] ALUFlags,
    output PCSrc,
    output RegWrite,
    output MemWrite
//    output reg [3:0] flags
    );
    
    reg CondEx ;
    reg N = 0, Z = 0, C = 0, V = 0 ;
    reg [1:0] FlagWrite;
    
    assign PCSrc = PCS & CondEx;
    assign RegWrite = RegW & CondEx & ~NoWrite; //CMP enhancement (~NoWrite) 
    assign MemWrite = MemW & CondEx;
            
    always@(posedge CLK)
    begin
        FlagWrite = FlagW & {CondEx, CondEx};
        {N, Z} = FlagWrite[1] ? ALUFlags[3:2] : 2'b00;
        {C, V} = FlagWrite[0] ? ALUFlags[1:0] : 2'b00;
//        {N, Z} = FlagWrite[1:0];
//        {C, V} = FlagW[0] ? ALUFlags[1:0] : 2'b11;
    end
    
    always@(Cond, N, Z, C, V)
    begin
        case(Cond)
            4'b0000: CondEx <= Z ;                  // EQ  
            4'b0001: CondEx <= ~Z ;                 // NE 
            4'b0010: CondEx <= C ;                  // CS / HS 
            4'b0011: CondEx <= ~C ;                 // CC / LO  
            
            4'b0100: CondEx <= N ;                  // MI  
            4'b0101: CondEx <= ~N ;                 // PL  
            4'b0110: CondEx <= V ;                  // VS  
            4'b0111: CondEx <= ~V ;                 // VC  
            
            4'b1000: CondEx <= (~Z) & C ;           // HI  
            4'b1001: CondEx <= Z | (~C) ;           // LS  
            4'b1010: CondEx <= N ~^ V ;             // GE  
            4'b1011: CondEx <= N ^ V ;              // LT  
            
            4'b1100: CondEx <= (~Z) & (N ~^ V) ;    // GT  
            4'b1101: CondEx <= Z | (N ^ V) ;        // LE  
            4'b1110: CondEx <= 1'b1  ;              // AL 
            4'b1111: CondEx <= 1'bx ;               // unpredictable   
        endcase   
    end
        

endmodule


//// Resettable Enabled Register (Example A.22)
//module resetEnabledRegister(
//    input clk, reset, en,
//    input  [1:0] d,
//    output reg [1:0] q);
    
//    //Synchronous reset
//    always @(posedge clk)
//        if(reset)
//            assign q = 2'b0;
//        else if(en)
//            assign q = d;
//        else
//            assign q = q; //Dont change the value

//endmodule