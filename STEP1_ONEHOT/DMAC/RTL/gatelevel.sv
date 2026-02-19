//**********************************************
//**********    gatelevel module   *************
    // ----------------------------------------------
    // 1. Arithmetic Units
    // ----------------------------------------------
    // 1) Adder (32bit)
    // SUM = A + 32'd4
    module ADD_4 (
        input  wire [31:0] A,
        input CLK,
        output wire [31:0] SUM
        );
        
        wire VDD, GND;
        XNOR2 U_VDD_GEN (.A1(CLK), .A2(CLK), .Y(VDD));  // 1
        XOR2  U_GND_GEN (.A1(CLK), .A2(CLK), .Y(GND));  // 0

        // carry wires
        wire c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16;
        wire c17, c18, c19, c20, c21, c22, c23, c24, c25, c26, c27, c28, c29, c30, c31;

        // bit0: SUM0 = A0
        XOR2 U_X0  (.A1(A[0]), .A2(GND), .Y(SUM[0]));
        AND2 U_C1  (.A1(A[0]), .A2(GND), .Y(c1));

        // bit1: SUM1 = A1
        XOR2 U_X1  (.A1(A[1]), .A2(c1),  .Y(SUM[1]));
        AND2 U_C2  (.A1(A[1]), .A2(c1),  .Y(c2));

        // bit2: SUM2 = ~A2, c3 = A2 
        XOR2 U_X2  (.A1(A[2]), .A2(VDD), .Y(SUM[2]));
        OR2  U_C3  (.A1(A[2]), .A2(c2),  .Y(c3));  

        // bit3 to bit15:
        // SUM[k] = A[k] XOR ck, ck+1 = A[k] & ck
        XOR2 U_X3  (.A1(A[3]), .A2(c3),  .Y(SUM[3]));
        AND2 U_A3  (.A1(A[3]), .A2(c3),  .Y(c4));

        XOR2 U_X4  (.A1(A[4]), .A2(c4),  .Y(SUM[4]));
        AND2 U_A4  (.A1(A[4]), .A2(c4),  .Y(c5));

        XOR2 U_X5  (.A1(A[5]), .A2(c5),  .Y(SUM[5]));
        AND2 U_A5  (.A1(A[5]), .A2(c5),  .Y(c6));

        XOR2 U_X6  (.A1(A[6]), .A2(c6),  .Y(SUM[6]));
        AND2 U_A6  (.A1(A[6]), .A2(c6),  .Y(c7));

        XOR2 U_X7  (.A1(A[7]), .A2(c7),  .Y(SUM[7]));
        AND2 U_A7  (.A1(A[7]), .A2(c7),  .Y(c8));

        XOR2 U_X8  (.A1(A[8]), .A2(c8),  .Y(SUM[8]));
        AND2 U_A8  (.A1(A[8]), .A2(c8),  .Y(c9));

        XOR2 U_X9  (.A1(A[9]), .A2(c9),  .Y(SUM[9]));
        AND2 U_A9 (.A1(A[9]), .A2(c9),  .Y(c10));

        XOR2 U_X10 (.A1(A[10]), .A2(c10), .Y(SUM[10]));
        AND2 U_A10 (.A1(A[10]), .A2(c10), .Y(c11));

        XOR2 U_X11 (.A1(A[11]), .A2(c11), .Y(SUM[11]));
        AND2 U_A11 (.A1(A[11]), .A2(c11), .Y(c12));

        XOR2 U_X12 (.A1(A[12]), .A2(c12), .Y(SUM[12]));
        AND2 U_A12 (.A1(A[12]), .A2(c12), .Y(c13));

        XOR2 U_X13 (.A1(A[13]), .A2(c13), .Y(SUM[13]));
        AND2 U_A13 (.A1(A[13]), .A2(c13), .Y(c14));

        XOR2 U_X14 (.A1(A[14]), .A2(c14), .Y(SUM[14]));
        AND2 U_A14 (.A1(A[14]), .A2(c14), .Y(c15));

        XOR2 U_X15 (.A1(A[15]), .A2(c15), .Y(SUM[15]));
        AND2 U_A15 (.A1(A[15]), .A2(c15), .Y(c16));

        XOR2 U_X16 (.A1(A[16]), .A2(c16), .Y(SUM[16]));
        AND2 U_A16 (.A1(A[16]), .A2(c16), .Y(c17));

        XOR2 U_X17 (.A1(A[17]), .A2(c17), .Y(SUM[17]));
        AND2 U_A17 (.A1(A[17]), .A2(c17), .Y(c18));

        XOR2 U_X18 (.A1(A[18]), .A2(c18), .Y(SUM[18]));
        AND2 U_A18 (.A1(A[18]), .A2(c18), .Y(c19));

        XOR2 U_X19 (.A1(A[19]), .A2(c19), .Y(SUM[19]));
        AND2 U_A19 (.A1(A[19]), .A2(c19), .Y(c20));

        XOR2 U_X20 (.A1(A[20]), .A2(c20), .Y(SUM[20]));
        AND2 U_A20 (.A1(A[20]), .A2(c20), .Y(c21));

        XOR2 U_X21 (.A1(A[21]), .A2(c21), .Y(SUM[21]));
        AND2 U_A21 (.A1(A[21]), .A2(c21), .Y(c22));

        XOR2 U_X22 (.A1(A[22]), .A2(c22), .Y(SUM[22]));
        AND2 U_A22 (.A1(A[22]), .A2(c22), .Y(c23));

        XOR2 U_X23 (.A1(A[23]), .A2(c23), .Y(SUM[23]));
        AND2 U_A23 (.A1(A[23]), .A2(c23), .Y(c24));

        XOR2 U_X24 (.A1(A[24]), .A2(c24), .Y(SUM[24]));
        AND2 U_A24 (.A1(A[24]), .A2(c24), .Y(c25));

        XOR2 U_X25 (.A1(A[25]), .A2(c25), .Y(SUM[25]));
        AND2 U_A25 (.A1(A[25]), .A2(c25), .Y(c26));

        XOR2 U_X26 (.A1(A[26]), .A2(c26), .Y(SUM[26]));
        AND2 U_A26 (.A1(A[26]), .A2(c26), .Y(c27));

        XOR2 U_X27 (.A1(A[27]), .A2(c27), .Y(SUM[27]));
        AND2 U_A27 (.A1(A[27]), .A2(c27), .Y(c28));

        XOR2 U_X28 (.A1(A[28]), .A2(c28), .Y(SUM[28]));
        AND2 U_A28 (.A1(A[28]), .A2(c28), .Y(c29));

        XOR2 U_X29 (.A1(A[29]), .A2(c29), .Y(SUM[29]));
        AND2 U_A29 (.A1(A[29]), .A2(c29), .Y(c30));

        XOR2 U_X30 (.A1(A[30]), .A2(c30), .Y(SUM[30]));
        AND2 U_A30 (.A1(A[30]), .A2(c30), .Y(c31));

        XOR2 U_X31 (.A1(A[31]), .A2(c31), .Y(SUM[31]));

    endmodule

    // ----------------------------------------------
    // 2) Subtractor (16bit)
    // AM4 = A - 16'd4
    // GT4  = (A > 4)
    module SUB_4 (
        input  wire [15:0] A,
        input CLK,
        output wire [15:0] AM4,
        output wire        GT4
        );

        wire VDD, GND;
        XNOR2 U_VDD_GEN (.A1(CLK), .A2(CLK), .Y(VDD));  // 1
        XOR2  U_GND_GEN (.A1(CLK), .A2(CLK), .Y(GND));  // 0

        // carry wires
        wire b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16;

        // bit0: AM40=A0
        XOR2 U_X0 (.A1(A[0]), .A2(GND), .Y(AM4[0]));

        // bit1: AM41=A1
        XOR2 U_X1 (.A1(A[1]), .A2(GND), .Y(AM4[1]));

        // bit2 : AM42=~A2
        XOR2 U_D2 (.A1(A[2]), .A2(VDD), .Y(AM4[2]));  // ~A2
        INV  U_B3 (.A(A[2]),            .Y(b3));    // b3 = ~A2

        // bit3 to bit15:
        // Each stage performs a ripple-like operation
        // Invert A[k] to generate nAi
        // XOR(A[k], previous carry) -> AM4[k]
        // AND(~A[k], previous carry) -> next carry
        // This forms a conditional bitwise inversion chain
        wire nA3; INV  U_NA3 (.A(A[3]), .Y(nA3));
        XOR2 U_X3 (.A1(A[3]), .A2(b3),  .Y(AM4[3]));
        AND2 U_A3 (.A1(nA3),  .A2(b3),  .Y(b4));

        // bit4
        wire nA4; INV  U_NA4 (.A(A[4]), .Y(nA4));
        XOR2 U_X4 (.A1(A[4]), .A2(b4),  .Y(AM4[4]));
        AND2 U_A4 (.A1(nA4),  .A2(b4),  .Y(b5));

        // bit5
        wire nA5; INV  U_NA5 (.A(A[5]), .Y(nA5));
        XOR2 U_X5 (.A1(A[5]), .A2(b5),  .Y(AM4[5]));
        AND2 U_A5 (.A1(nA5),  .A2(b5),  .Y(b6));

        // bit6
        wire nA6; INV  U_NA6 (.A(A[6]), .Y(nA6));
        XOR2 U_X6 (.A1(A[6]), .A2(b6),  .Y(AM4[6]));
        AND2 U_A6 (.A1(nA6),  .A2(b6),  .Y(b7));

        // bit7
        wire nA7; INV  U_NA7 (.A(A[7]), .Y(nA7));
        XOR2 U_X7 (.A1(A[7]), .A2(b7),  .Y(AM4[7]));
        AND2 U_A7 (.A1(nA7),  .A2(b7),  .Y(b8));

        // bit8
        wire nA8; INV  U_NA8 (.A(A[8]), .Y(nA8));
        XOR2 U_X8 (.A1(A[8]), .A2(b8),  .Y(AM4[8]));
        AND2 U_A8 (.A1(nA8),  .A2(b8),  .Y(b9));

        // bit9
        wire nA9; INV  U_NA9 (.A(A[9]), .Y(nA9));
        XOR2 U_X9  (.A1(A[9]),  .A2(b9),   .Y(AM4[9]));
        AND2 U_A9 (.A1(nA9),   .A2(b9),   .Y(b10));

        // bit10
        wire nA10; INV  U_NA10 (.A(A[10]), .Y(nA10));
        XOR2 U_X10 (.A1(A[10]), .A2(b10),  .Y(AM4[10]));
        AND2 U_A10 (.A1(nA10),  .A2(b10),  .Y(b11));

        // bit11
        wire nA11; INV  U_NA11 (.A(A[11]), .Y(nA11));
        XOR2 U_X11 (.A1(A[11]), .A2(b11),  .Y(AM4[11]));
        AND2 U_A11 (.A1(nA11),  .A2(b11),  .Y(b12));

        // bit12
        wire nA12; INV  U_NA12 (.A(A[12]), .Y(nA12));
        XOR2 U_X12 (.A1(A[12]), .A2(b12),  .Y(AM4[12]));
        AND2 U_A12 (.A1(nA12),  .A2(b12),  .Y(b13));

        // bit13
        wire nA13; INV  U_NA13 (.A(A[13]), .Y(nA13));
        XOR2 U_X13 (.A1(A[13]), .A2(b13),  .Y(AM4[13]));
        AND2 U_A13 (.A1(nA13),  .A2(b13),  .Y(b14));

        // bit14
        wire nA14; INV  U_NA14 (.A(A[14]), .Y(nA14));
        XOR2 U_X14 (.A1(A[14]), .A2(b14),  .Y(AM4[14]));
        AND2 U_A14 (.A1(nA14),  .A2(b14),  .Y(b15));

        // bit15
        wire nA15; INV  U_NA15 (.A(A[15]), .Y(nA15));
        XOR2 U_X15 (.A1(A[15]), .A2(b15),  .Y(AM4[15]));
        AND2 U_A15 (.A1(nA15),  .A2(b15),  .Y(b16));

        // ----------------------------------------------
        // GT4 signal generation
        // GT4 = (A > 4)
        // GT4 becomes 1 if any upper bits A[15:3] are set,
        // or if A[2] is 1 and at least one of A[1] or A[0] is 1
        // ----------------------------------------------
        wire or_3_5, or_6_8, or_9_11, or_12_14, or_3_8, or_9_14, or_3_14, or_3_15;
        OR3 U_OR_3_5   (.A1(A[3]),  .A2(A[4]),  .A3(A[5]),  .Y(or_3_5));
        OR3 U_OR_6_8   (.A1(A[6]),  .A2(A[7]),  .A3(A[8]),  .Y(or_6_8));
        OR3 U_OR_9_11  (.A1(A[9]),  .A2(A[10]), .A3(A[11]), .Y(or_9_11));
        OR3 U_OR_12_14 (.A1(A[12]), .A2(A[13]), .A3(A[14]), .Y(or_12_14));

        OR2 U_OR_3_8 (.A1(or_3_5),   .A2(or_6_8),    .Y(or_3_8));
        OR2 U_OR_9_14 (.A1(or_9_11),  .A2(or_12_14), .Y(or_9_14));
        OR2 U_OR_3_14 (.A1(or_3_8),  .A2(or_9_14),   .Y(or_3_14));
        OR2 U_OR_3_15 (.A1(or_3_14),  .A2(A[15]),    .Y(or_3_15));

        wire a1_or_a0, a2_and_a1_or_a0;
        OR2  U_A1_OR_0 (.A1(A[1]), .A2(A[0]),     .Y(a1_or_a0));
        AND2 U_A2_AND_1_OR_0 (.A1(A[2]), .A2(a1_or_a0), .Y(a2_and_a1_or_a0));

        OR2 U_GT4 (.A1(or_3_15), .A2(a2_and_a1_or_a0), .Y(GT4));
    endmodule

    // ----------------------------------------------
    // 2. MUX (16bit, 32bit)
    // ----------------------------------------------
    // 1) 16-bit MUX
    module MUX21_16B (input [15:0] A1, input [15:0] A2, input S0, output [15:0] Y);
        MUX21 U_M00 (.A1(A1[0]),  .A2(A2[0]),  .S0(S0), .Y(Y[0]));
        MUX21 U_M01 (.A1(A1[1]),  .A2(A2[1]),  .S0(S0), .Y(Y[1]));
        MUX21 U_M02 (.A1(A1[2]),  .A2(A2[2]),  .S0(S0), .Y(Y[2]));
        MUX21 U_M03 (.A1(A1[3]),  .A2(A2[3]),  .S0(S0), .Y(Y[3]));
        MUX21 U_M04 (.A1(A1[4]),  .A2(A2[4]),  .S0(S0), .Y(Y[4]));
        MUX21 U_M05 (.A1(A1[5]),  .A2(A2[5]),  .S0(S0), .Y(Y[5]));
        MUX21 U_M06 (.A1(A1[6]),  .A2(A2[6]),  .S0(S0), .Y(Y[6]));
        MUX21 U_M07 (.A1(A1[7]),  .A2(A2[7]),  .S0(S0), .Y(Y[7]));
        MUX21 U_M08 (.A1(A1[8]),  .A2(A2[8]),  .S0(S0), .Y(Y[8]));
        MUX21 U_M09 (.A1(A1[9]),  .A2(A2[9]),  .S0(S0), .Y(Y[9]));
        MUX21 U_M10 (.A1(A1[10]), .A2(A2[10]), .S0(S0), .Y(Y[10]));
        MUX21 U_M11 (.A1(A1[11]), .A2(A2[11]), .S0(S0), .Y(Y[11]));
        MUX21 U_M12 (.A1(A1[12]), .A2(A2[12]), .S0(S0), .Y(Y[12]));
        MUX21 U_M13 (.A1(A1[13]), .A2(A2[13]), .S0(S0), .Y(Y[13]));
        MUX21 U_M14 (.A1(A1[14]), .A2(A2[14]), .S0(S0), .Y(Y[14]));
        MUX21 U_M15 (.A1(A1[15]), .A2(A2[15]), .S0(S0), .Y(Y[15]));
    endmodule

    // 2) 32-bit MUX
    module MUX21_32B (input [31:0] A1, input [31:0] A2, input S0, output [31:0] Y);
        MUX21 U_M00 (.A1(A1[0]),  .A2(A2[0]),  .S0(S0), .Y(Y[0]));
        MUX21 U_M01 (.A1(A1[1]),  .A2(A2[1]),  .S0(S0), .Y(Y[1]));
        MUX21 U_M02 (.A1(A1[2]),  .A2(A2[2]),  .S0(S0), .Y(Y[2]));
        MUX21 U_M03 (.A1(A1[3]),  .A2(A2[3]),  .S0(S0), .Y(Y[3]));
        MUX21 U_M04 (.A1(A1[4]),  .A2(A2[4]),  .S0(S0), .Y(Y[4]));
        MUX21 U_M05 (.A1(A1[5]),  .A2(A2[5]),  .S0(S0), .Y(Y[5]));
        MUX21 U_M06 (.A1(A1[6]),  .A2(A2[6]),  .S0(S0), .Y(Y[6]));
        MUX21 U_M07 (.A1(A1[7]),  .A2(A2[7]),  .S0(S0), .Y(Y[7]));
        MUX21 U_M08 (.A1(A1[8]),  .A2(A2[8]),  .S0(S0), .Y(Y[8]));
        MUX21 U_M09 (.A1(A1[9]),  .A2(A2[9]),  .S0(S0), .Y(Y[9]));
        MUX21 U_M10 (.A1(A1[10]), .A2(A2[10]), .S0(S0), .Y(Y[10]));
        MUX21 U_M11 (.A1(A1[11]), .A2(A2[11]), .S0(S0), .Y(Y[11]));
        MUX21 U_M12 (.A1(A1[12]), .A2(A2[12]), .S0(S0), .Y(Y[12]));
        MUX21 U_M13 (.A1(A1[13]), .A2(A2[13]), .S0(S0), .Y(Y[13]));
        MUX21 U_M14 (.A1(A1[14]), .A2(A2[14]), .S0(S0), .Y(Y[14]));
        MUX21 U_M15 (.A1(A1[15]), .A2(A2[15]), .S0(S0), .Y(Y[15]));
        MUX21 U_M16 (.A1(A1[16]), .A2(A2[16]), .S0(S0), .Y(Y[16]));
        MUX21 U_M17 (.A1(A1[17]), .A2(A2[17]), .S0(S0), .Y(Y[17]));
        MUX21 U_M18 (.A1(A1[18]), .A2(A2[18]), .S0(S0), .Y(Y[18]));
        MUX21 U_M19 (.A1(A1[19]), .A2(A2[19]), .S0(S0), .Y(Y[19]));
        MUX21 U_M20 (.A1(A1[20]), .A2(A2[20]), .S0(S0), .Y(Y[20]));
        MUX21 U_M21 (.A1(A1[21]), .A2(A2[21]), .S0(S0), .Y(Y[21]));
        MUX21 U_M22 (.A1(A1[22]), .A2(A2[22]), .S0(S0), .Y(Y[22]));
        MUX21 U_M23 (.A1(A1[23]), .A2(A2[23]), .S0(S0), .Y(Y[23]));
        MUX21 U_M24 (.A1(A1[24]), .A2(A2[24]), .S0(S0), .Y(Y[24]));
        MUX21 U_M25 (.A1(A1[25]), .A2(A2[25]), .S0(S0), .Y(Y[25]));
        MUX21 U_M26 (.A1(A1[26]), .A2(A2[26]), .S0(S0), .Y(Y[26]));
        MUX21 U_M27 (.A1(A1[27]), .A2(A2[27]), .S0(S0), .Y(Y[27]));
        MUX21 U_M28 (.A1(A1[28]), .A2(A2[28]), .S0(S0), .Y(Y[28]));
        MUX21 U_M29 (.A1(A1[29]), .A2(A2[29]), .S0(S0), .Y(Y[29]));
        MUX21 U_M30 (.A1(A1[30]), .A2(A2[30]), .S0(S0), .Y(Y[30]));
        MUX21 U_M31 (.A1(A1[31]), .A2(A2[31]), .S0(S0), .Y(Y[31]));
    endmodule
    // ----------------------------------------------
    // 3. Registers
    // ----------------------------------------------
    // 1) 32-bit Register
    module REG32 (
    input  wire        CLK,
    input  wire        RST_n,
    input  wire [31:0] D,
    output wire [31:0] Q
    );

    DFF U_D0  (.D(D[0]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[0]),  .QN());
    DFF U_D1  (.D(D[1]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[1]),  .QN());
    DFF U_D2  (.D(D[2]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[2]),  .QN());
    DFF U_D3  (.D(D[3]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[3]),  .QN());
    DFF U_D4  (.D(D[4]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[4]),  .QN());
    DFF U_D5  (.D(D[5]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[5]),  .QN());
    DFF U_D6  (.D(D[6]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[6]),  .QN());
    DFF U_D7  (.D(D[7]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[7]),  .QN());
    DFF U_D8  (.D(D[8]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[8]),  .QN());
    DFF U_D9  (.D(D[9]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[9]),  .QN());
    DFF U_D10 (.D(D[10]), .RST_n(RST_n), .CLK(CLK), .Q(Q[10]), .QN());
    DFF U_D11 (.D(D[11]), .RST_n(RST_n), .CLK(CLK), .Q(Q[11]), .QN());
    DFF U_D12 (.D(D[12]), .RST_n(RST_n), .CLK(CLK), .Q(Q[12]), .QN());
    DFF U_D13 (.D(D[13]), .RST_n(RST_n), .CLK(CLK), .Q(Q[13]), .QN());
    DFF U_D14 (.D(D[14]), .RST_n(RST_n), .CLK(CLK), .Q(Q[14]), .QN());
    DFF U_D15 (.D(D[15]), .RST_n(RST_n), .CLK(CLK), .Q(Q[15]), .QN());
    DFF U_D16 (.D(D[16]), .RST_n(RST_n), .CLK(CLK), .Q(Q[16]), .QN());
    DFF U_D17 (.D(D[17]), .RST_n(RST_n), .CLK(CLK), .Q(Q[17]), .QN());
    DFF U_D18 (.D(D[18]), .RST_n(RST_n), .CLK(CLK), .Q(Q[18]), .QN());
    DFF U_D19 (.D(D[19]), .RST_n(RST_n), .CLK(CLK), .Q(Q[19]), .QN());
    DFF U_D20 (.D(D[20]), .RST_n(RST_n), .CLK(CLK), .Q(Q[20]), .QN());
    DFF U_D21 (.D(D[21]), .RST_n(RST_n), .CLK(CLK), .Q(Q[21]), .QN());
    DFF U_D22 (.D(D[22]), .RST_n(RST_n), .CLK(CLK), .Q(Q[22]), .QN());
    DFF U_D23 (.D(D[23]), .RST_n(RST_n), .CLK(CLK), .Q(Q[23]), .QN());
    DFF U_D24 (.D(D[24]), .RST_n(RST_n), .CLK(CLK), .Q(Q[24]), .QN());
    DFF U_D25 (.D(D[25]), .RST_n(RST_n), .CLK(CLK), .Q(Q[25]), .QN());
    DFF U_D26 (.D(D[26]), .RST_n(RST_n), .CLK(CLK), .Q(Q[26]), .QN());
    DFF U_D27 (.D(D[27]), .RST_n(RST_n), .CLK(CLK), .Q(Q[27]), .QN());
    DFF U_D28 (.D(D[28]), .RST_n(RST_n), .CLK(CLK), .Q(Q[28]), .QN());
    DFF U_D29 (.D(D[29]), .RST_n(RST_n), .CLK(CLK), .Q(Q[29]), .QN());
    DFF U_D30 (.D(D[30]), .RST_n(RST_n), .CLK(CLK), .Q(Q[30]), .QN());
    DFF U_D31 (.D(D[31]), .RST_n(RST_n), .CLK(CLK), .Q(Q[31]), .QN());
    endmodule

    // 2) 16-bit Register
    module REG16 (
    input  wire        CLK,
    input  wire        RST_n,
    input  wire [15:0] D,
    output wire [15:0] Q
    );

    DFF U_D0  (.D(D[0]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[0]),  .QN());
    DFF U_D1  (.D(D[1]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[1]),  .QN());
    DFF U_D2  (.D(D[2]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[2]),  .QN());
    DFF U_D3  (.D(D[3]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[3]),  .QN());
    DFF U_D4  (.D(D[4]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[4]),  .QN());
    DFF U_D5  (.D(D[5]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[5]),  .QN());
    DFF U_D6  (.D(D[6]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[6]),  .QN());
    DFF U_D7  (.D(D[7]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[7]),  .QN());
    DFF U_D8  (.D(D[8]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[8]),  .QN());
    DFF U_D9  (.D(D[9]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[9]),  .QN());
    DFF U_D10 (.D(D[10]), .RST_n(RST_n), .CLK(CLK), .Q(Q[10]), .QN());
    DFF U_D11 (.D(D[11]), .RST_n(RST_n), .CLK(CLK), .Q(Q[11]), .QN());
    DFF U_D12 (.D(D[12]), .RST_n(RST_n), .CLK(CLK), .Q(Q[12]), .QN());
    DFF U_D13 (.D(D[13]), .RST_n(RST_n), .CLK(CLK), .Q(Q[13]), .QN());
    DFF U_D14 (.D(D[14]), .RST_n(RST_n), .CLK(CLK), .Q(Q[14]), .QN());
    DFF U_D15 (.D(D[15]), .RST_n(RST_n), .CLK(CLK), .Q(Q[15]), .QN());
    endmodule
    
    // 3) 5-bit Register
    module REG5 (
    input  wire        CLK,
    input  wire        RST_n,
    input  wire [4:0] D,
    output wire [4:0] Q
    );

    DFF U_D0  (.D(D[0]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[0]),  .QN());
    DFF U_D1  (.D(D[1]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[1]),  .QN());
    DFF U_D2  (.D(D[2]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[2]),  .QN());
    DFF U_D3  (.D(D[3]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[3]),  .QN());
    DFF U_D4  (.D(D[4]),  .RST_n(RST_n), .CLK(CLK), .Q(Q[4]),  .QN());
    endmodule

    // ----------------------------------------------
    // 4. 1-bit buffer
    // ----------------------------------------------
    module BUF (input A, output Y);
        wire n1;
        INV U_I1 (.A(A), .Y(n1));
        INV U_I2 (.A(n1), .Y(Y));
    endmodule