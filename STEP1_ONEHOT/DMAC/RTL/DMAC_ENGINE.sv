// Copyright (c) 2021 Sungkyunkwan University
//
// Authors:
// - Jungrae Kim <dale40@skku.edu>

module DMAC_ENGINE
(
    input   wire                clk,
    input   wire                rst_n,  // _n means active low

    // configuration registers
    input   wire    [31:0]      src_addr_i,
    input   wire    [31:0]      dst_addr_i,
    input   wire    [15:0]      byte_len_i,
    input   wire                start_i,
    output  wire                done_o,

    // AMBA AXI interface (AW channel)
    output  wire    [3:0]       awid_o,
    output  wire    [31:0]      awaddr_o,
    output  wire    [3:0]       awlen_o,
    output  wire    [2:0]       awsize_o,
    output  wire    [1:0]       awburst_o,
    output  wire                awvalid_o,
    input   wire                awready_i,

    // AMBA AXI interface (W channel)
    output  wire    [3:0]       wid_o,
    output  wire    [31:0]      wdata_o,
    output  wire    [3:0]       wstrb_o,
    output  wire                wlast_o,
    output  wire                wvalid_o,
    input   wire                wready_i,

    // AMBA AXI interface (B channel)
    input   wire    [3:0]       bid_i,
    input   wire    [1:0]       bresp_i,
    input   wire                bvalid_i,
    output  wire                bready_o,

    // AMBA AXI interface (AR channel)
    output  wire    [3:0]       arid_o,
    output  wire    [31:0]      araddr_o,
    output  wire    [3:0]       arlen_o,
    output  wire    [2:0]       arsize_o,
    output  wire    [1:0]       arburst_o,
    output  wire                arvalid_o,
    input   wire                arready_i,

    // AMBA AXI interface (R channel)
    input   wire    [3:0]       rid_i,
    input   wire    [31:0]      rdata_i,
    input   wire    [1:0]       rresp_i,
    input   wire                rlast_i,
    input   wire                rvalid_i,
    output  wire                rready_o
);


    localparam                  S_IDLE  = 'd0,
                                S_RREQ  = 'd1,
                                S_RDATA = 'd2,
                                S_WREQ  = 'd3,
                                S_WDATA = 'd4;

    wire     [4:0]              state,      state_n;

    wire     [31:0]             src_addr,   src_addr_n;
    wire     [31:0]             dst_addr,   dst_addr_n;
    wire     [15:0]             cnt,        cnt_n;
    wire     [31:0]             data_buf,   data_buf_n;

    wire                        arvalid,
                                rready,
                                awvalid,
                                wvalid,
                                done;


//**********************************************
//*********  STEP1: one-hot encoding   *********
    // ----------------------------------------------
    // 0. Intermediate signals
    // ----------------------------------------------
    // 1-1) Check if the input length (byte_len_i) is zero or not
    // len_eq_0 = 1 when all bits are 0
    // len_ne_0 = 1 when any bit is 1
    wire b01, b23, b45, b67, b89, bAB, bCD, bEF;
    OR2 U_B01 (.A1(byte_len_i[0]),  .A2(byte_len_i[1]),  .Y(b01));
    OR2 U_B23 (.A1(byte_len_i[2]),  .A2(byte_len_i[3]),  .Y(b23));
    OR2 U_B45 (.A1(byte_len_i[4]),  .A2(byte_len_i[5]),  .Y(b45));
    OR2 U_B67 (.A1(byte_len_i[6]),  .A2(byte_len_i[7]),  .Y(b67));
    OR2 U_B89 (.A1(byte_len_i[8]),  .A2(byte_len_i[9]),  .Y(b89));
    OR2 U_BAB (.A1(byte_len_i[10]), .A2(byte_len_i[11]), .Y(bAB));
    OR2 U_BCD (.A1(byte_len_i[12]), .A2(byte_len_i[13]), .Y(bCD));
    OR2 U_BEF (.A1(byte_len_i[14]), .A2(byte_len_i[15]), .Y(bEF));

    wire b_a, b_b, b_c, b_d, b_e, b_f, b_all;
    OR2 U_Ba (.A1(b01), .A2(b23), .Y(b_a));
    OR2 U_Bb (.A1(b45), .A2(b67), .Y(b_b));
    OR2 U_Bc (.A1(b89), .A2(bAB), .Y(b_c));
    OR2 U_Bd (.A1(bCD), .A2(bEF), .Y(b_d));
    OR2 U_Be (.A1(b_a), .A2(b_b), .Y(b_e));
    OR2 U_Bf (.A1(b_c), .A2(b_d), .Y(b_f));
    OR2 U_Bg (.A1(b_e), .A2(b_f), .Y(b_all));

    wire len_eq_0, len_ne_0;
    INV  U_LEN_EQ0 (.A(b_all), .Y(len_eq_0)); // len==0
    INV  U_LEN_NE0 (.A(len_eq_0), .Y(len_ne_0)); // len!=0

    // 1-2) Check if the cnt is zero or not
    // cnt_eq_0 = 1 when all bits are 0
    // cnt_ne_0 = 1 when any bit is 1
    wire c01, c23, c45, c67, c89, cAB, cCD, cEF;
    OR2 U_C01 (.A1(cnt[0]),  .A2(cnt[1]),  .Y(c01));
    OR2 U_C23 (.A1(cnt[2]),  .A2(cnt[3]),  .Y(c23));
    OR2 U_C45 (.A1(cnt[4]),  .A2(cnt[5]),  .Y(c45));
    OR2 U_C67 (.A1(cnt[6]),  .A2(cnt[7]),  .Y(c67));
    OR2 U_C89 (.A1(cnt[8]),  .A2(cnt[9]),  .Y(c89));
    OR2 U_CAB (.A1(cnt[10]), .A2(cnt[11]), .Y(cAB));
    OR2 U_CCD (.A1(cnt[12]), .A2(cnt[13]), .Y(cCD));
    OR2 U_CEF (.A1(cnt[14]), .A2(cnt[15]), .Y(cEF));

    wire c_a, c_b, c_c, c_d, c_e, c_f, c_all;
    OR2 U_Ca (.A1(c01), .A2(c23), .Y(c_a));
    OR2 U_Cb (.A1(c45), .A2(c67), .Y(c_b));
    OR2 U_Cc (.A1(c89), .A2(cAB), .Y(c_c));
    OR2 U_Cd (.A1(cCD), .A2(cEF), .Y(c_d));
    OR2 U_Ce (.A1(c_a), .A2(c_b), .Y(c_e));
    OR2 U_Cf (.A1(c_c), .A2(c_d), .Y(c_f));
    OR2 U_Cg (.A1(c_e), .A2(c_f), .Y(c_all));

    wire cnt_eq_0, cnt_ne_0;
    INV  U_CNT_EQ0 (.A(c_all), .Y(cnt_eq_0)); // cnt==0
    INV  U_CNT_NE0 (.A(cnt_eq_0), .Y(cnt_ne_0)); // cnt!=0


    // 2) IDLE state transition or stay signals
    // When start_i is high and length is not zero, move to RREQ
    // Otherwise, stay in IDLE
    wire start_i_and_len_ne_0, n_start_i_and_len_ne_0;
    AND2 IDLE_TO_RREQ (.A1(start_i), .A2(len_ne_0), .Y(start_i_and_len_ne_0)); // IDLE->RREQ
    INV  IDLE_STAY (.A(start_i_and_len_ne_0), .Y(n_start_i_and_len_ne_0)); // IDLE stay
    
    // 3) WDATA state transition signals
    // When wready_i is high and cnt == 0 -> go back to IDLE
    // When wready_i is high and cnt != 0 -> move to RREQ again
    wire wready_i_and_cnt_eq_0, wready_i_and_cnt_ne_0;
    AND2 WDATA_TO_IDLE (.A1(wready_i), .A2(cnt_eq_0), .Y(wready_i_and_cnt_eq_0)); //WDATA->IDLE
    AND2 WDATA_TO_RREQ (.A1(wready_i), .A2(cnt_ne_0), .Y(wready_i_and_cnt_ne_0)); //WDATA->RREQ
    
    // 4) Complementary ready/valid signals
    // Used to describe stay conditions when channel is not ready
    wire n_arready, n_rvalid, n_awready, n_wready;
    INV U_NAR (.A(arready_i), .Y(n_arready));   // RREQ stay
    INV U_NRV (.A(rvalid_i),  .Y(n_rvalid));    // RDATA stay
    INV U_NAW (.A(awready_i), .Y(n_awready));   // WREQ  stay
    INV U_NWR (.A(wready_i),  .Y(n_wready));    // WDATA stay

    // 5) After reset release: if all state bits are 0, force state_n[S_IDLE] = 1 to initialize the FSM.
    // all_zero = ~(state[IDLE] | state[RREQ] | state[RDATA] | state[WREQ] | state[WDATA])
    // ----------------------------------------------
    wire or012, or34, or_all, all_zero;
    OR3 U_OR012 (.A1(state[S_IDLE]),  .A2(state[S_RREQ]),  .A3(state[S_RDATA]), .Y(or012));
    OR2 U_OR34  (.A1(state[S_WREQ]),  .A2(state[S_WDATA]), .Y(or34));
    OR2 U_ORALL (.A1(or012),          .A2(or34),           .Y(or_all));
    INV U_ALL0  (.A(or_all),          .Y(all_zero)); // If all bits are 0 than 'all_zero' is 1.

    // ----------------------------------------------
    // 1. Next state logic
    // ----------------------------------------------
    // 0) state_n[S_IDLE] = (state[IDLE]  & n_start_i_and_len_ne_0)
    //                 | (state[WDATA] & wready_i_and_cnt_eq_0)
    //                 | all_zero
    wire stay_idle, from_wdt_to_idle, idle_or_1;
    AND2 U_IDLE_STAY   (.A1(state[S_IDLE]),  .A2(n_start_i_and_len_ne_0), .Y(stay_idle));
    AND2 U_WDT_TO_IDLE (.A1(state[S_WDATA]), .A2(wready_i_and_cnt_eq_0),  .Y(from_wdt_to_idle));
    OR2  U_IDLE_OR0    (.A1(stay_idle),      .A2(from_wdt_to_idle),       .Y(idle_or_1));
    OR2  U_IDLE_OR1    (.A1(idle_or_1),      .A2(all_zero),               .Y(state_n[S_IDLE]));

    // 1) state_n[S_RREQ] = (state[IDLE]  & start_i_and_len_ne_0)
    //                 | (state[WDATA] & wready_i_and_cnt_ne_0)
    //                 | (state[RREQ]  & n_arready)
    wire from_idle_to_rreq, from_wdt_to_rreq, stay_rreq, rreq_or_1;
    AND2 U_I_TO_RREQ   (.A1(state[S_IDLE]),  .A2(start_i_and_len_ne_0),   .Y(from_idle_to_rreq));
    AND2 U_WDT_TO_RREQ (.A1(state[S_WDATA]), .A2(wready_i_and_cnt_ne_0),  .Y(from_wdt_to_rreq));
    AND2 U_RREQ_STAY   (.A1(state[S_RREQ]),  .A2(n_arready),              .Y(stay_rreq));
    OR2  U_RREQ_OR0    (.A1(from_idle_to_rreq), .A2(from_wdt_to_rreq),    .Y(rreq_or_1));
    OR2  U_RREQ_OR1    (.A1(rreq_or_1),         .A2(stay_rreq),           .Y(state_n[S_RREQ]));

    // 2) state_n[S_RDATA] = (state[RREQ]  & arready_i)
    //                  | (state[RDATA] & n_rvalid)
    wire from_rreq_to_rdata, stay_rdata;
    AND2 U_RREQ_TO_RDT (.A1(state[S_RREQ]),  .A2(arready_i),              .Y(from_rreq_to_rdata));
    AND2 U_RDT_STAY    (.A1(state[S_RDATA]), .A2(n_rvalid),               .Y(stay_rdata));
    OR2  U_RDT_OR      (.A1(from_rreq_to_rdata), .A2(stay_rdata),         .Y(state_n[S_RDATA]));

    // 3) state_n[S_WREQ] = (state[RDATA] & rvalid_i)
    //                 | (state[WREQ]  & n_awready)
    wire from_rdata_to_wreq, stay_wreq;
    AND2 U_RDT_TO_WREQ (.A1(state[S_RDATA]), .A2(rvalid_i),               .Y(from_rdata_to_wreq));
    AND2 U_WREQ_STAY   (.A1(state[S_WREQ]),  .A2(n_awready),              .Y(stay_wreq));
    OR2  U_WREQ_OR     (.A1(from_rdata_to_wreq), .A2(stay_wreq),          .Y(state_n[S_WREQ]));

    // 4) state_n[S_WDATA] = (state[WREQ]  & awready_i)
    //                  | (state[WDATA] & n_wready)
    wire from_wreq_to_wdata, stay_wdata;
    AND2 U_WREQ_TO_WDT (.A1(state[S_WREQ]),  .A2(awready_i),              .Y(from_wreq_to_wdata));
    AND2 U_WDT_STAY    (.A1(state[S_WDATA]), .A2(n_wready),               .Y(stay_wdata));
    OR2  U_WDT_OR      (.A1(from_wreq_to_wdata), .A2(stay_wdata),         .Y(state_n[S_WDATA]));

    // ----------------------------------------------
    // 2. On moving out
    // ----------------------------------------------
    // 0) GND BUS
    wire [15:0] GND_bus;
    XOR2 G0 (.A1(clk), .A2(clk), .Y(GND_bus[0]));
    XOR2 G1 (.A1(clk), .A2(clk), .Y(GND_bus[1]));
    XOR2 G2 (.A1(clk), .A2(clk), .Y(GND_bus[2]));
    XOR2 G3 (.A1(clk), .A2(clk), .Y(GND_bus[3]));
    XOR2 G4 (.A1(clk), .A2(clk), .Y(GND_bus[4]));
    XOR2 G5 (.A1(clk), .A2(clk), .Y(GND_bus[5]));
    XOR2 G6 (.A1(clk), .A2(clk), .Y(GND_bus[6]));
    XOR2 G7 (.A1(clk), .A2(clk), .Y(GND_bus[7]));
    XOR2 G8 (.A1(clk), .A2(clk), .Y(GND_bus[8]));
    XOR2 G9 (.A1(clk), .A2(clk), .Y(GND_bus[9]));
    XOR2 G10 (.A1(clk), .A2(clk), .Y(GND_bus[10]));
    XOR2 G11 (.A1(clk), .A2(clk), .Y(GND_bus[11]));
    XOR2 G12 (.A1(clk), .A2(clk), .Y(GND_bus[12]));
    XOR2 G13 (.A1(clk), .A2(clk), .Y(GND_bus[13]));
    XOR2 G14 (.A1(clk), .A2(clk), .Y(GND_bus[14]));
    XOR2 G15 (.A1(clk), .A2(clk), .Y(GND_bus[15]));
    
    // 1) Adder
    wire [31:0] src_addr_p4, dst_addr_p4;
    ADD_4 U_SRC_P4 (.A(src_addr), .CLK(clk), .SUM(src_addr_p4));
    ADD_4 U_DST_P4 (.A(dst_addr), .CLK(clk), .SUM(dst_addr_p4));

    // 2) Subtractor
    // Subtracts 4 from cnt and outputs the result to cnt_m4.
    // If cnt is greater than or equal to 4, the result is cnt - 4.
    // If cnt is less than 4, cnt_gt_4 becomes 0
    wire [15:0] cnt_m4;
    wire        cnt_gt_4;
    wire [15:0] cnt_m4_or0;
    SUB_4 U_CNT_M4 (.A(cnt), .CLK(clk), .AM4(cnt_m4), .GT4(cnt_gt_4));
    MUX21_16B U_CNT_M4_OR0 (
    .A1(cnt_m4), .A2(GND_bus), .S0(cnt_gt_4), .Y(cnt_m4_or0)
    );
    
    // 3) MUX chain
    // src_addr_n
    // Increase src_addr by +4 when RREQ -> RDATA
    // Load src_addr_i to src_addr when IDLE -> RREQ
    wire [31:0] src_sel1;
    MUX21_32B U_SRC_SEL1 (
    .A1(src_addr_p4), .A2(src_addr), .S0(from_rreq_to_rdata), .Y(src_sel1)
    );
    MUX21_32B U_SRC_SEL2 (
    .A1(src_addr_i), .A2(src_sel1), .S0(from_idle_to_rreq), .Y(src_addr_n)
    );

    // dst_addr_n
    // Increase dst_addr by +4 when WREQ -> WDATA
    // Load dst_addr_i to dst_addr when IDLE -> RREQ
    wire [31:0] dst_sel1;
    MUX21_32B U_DST_SEL1 (
    .A1(dst_addr_p4), .A2(dst_addr), .S0(from_wreq_to_wdata), .Y(dst_sel1)
    );
    MUX21_32B U_DST_SEL2 (
    .A1(dst_addr_i), .A2(dst_sel1), .S0(from_idle_to_rreq),   .Y(dst_addr_n)
    );
    // cnt_n
    // Decrease cnt by -4 when WREQ -> WDATA
    // Load byte_len_i to cnt when IDLE -> RREQ
    wire [15:0] cnt_sel1;
    MUX21_16B U_CNT_SEL1 (
    .A1(cnt_m4_or0), .A2(cnt), .S0(from_wreq_to_wdata), .Y(cnt_sel1)
    );
    MUX21_16B U_CNT_SEL2 (
    .A1(byte_len_i), .A2(cnt_sel1), .S0(from_idle_to_rreq),  .Y(cnt_n)
    );
    // data_buf_n
    // Load rdata_i to data_buf when RDATA -> WREQ
    MUX21_32B U_DBUF_SEL (
    .A1(rdata_i), .A2(data_buf), .S0(from_rdata_to_wreq), .Y(data_buf_n)
    );

    // ----------------------------------------------
    // 3. Register update stage
    // This stage transfers all next cycle values into their corresponding registers.
    // The FSM next state (state_n) becomes the current state (state).
    // And the same applies to src_addr, dst_addr, data_buf, and cnt.
    // ----------------------------------------------
    REG5 U_STATE_REG (.CLK(clk), .RST_n(rst_n), .D(state_n), .Q(state));
    REG32 U_SRC_REG (.CLK(clk), .RST_n(rst_n), .D(src_addr_n), .Q(src_addr));
    REG32 U_DST_REG (.CLK(clk), .RST_n(rst_n), .D(dst_addr_n), .Q(dst_addr));
    REG32 U_DATA_BUF_REG (.CLK(clk), .RST_n(rst_n), .D(data_buf_n), .Q(data_buf));
    REG16 U_CNT_REG (.CLK(clk), .RST_n(rst_n), .D(cnt_n), .Q(cnt));

    // ----------------------------------------------
    // 4. Outputs
    // ----------------------------------------------
    BUF U_ARV (.A(state[S_RREQ]),  .Y(arvalid));
    BUF U_RRD (.A(state[S_RDATA]), .Y(rready));
    BUF U_AWV (.A(state[S_WREQ]),  .Y(awvalid));
    BUF U_WV  (.A(state[S_WDATA]), .Y(wvalid));
    BUF U_DN  (.A(state[S_IDLE]),  .Y(done));


    //  FILL YOUR CODE HERE
    // ----------------------


    
    // Output assigments
    assign  done_o                  = done;

    assign  awid_o                  = 4'd0;
    assign  awaddr_o                = dst_addr;
    assign  awlen_o                 = 4'd0;     // 1-burst
    assign  awsize_o                = 3'b010;   // 4 bytes per transfer
    assign  awburst_o               = 2'b01;    // incremental
    assign  awvalid_o               = awvalid;

    assign  wid_o                   = 4'd0;
    assign  wdata_o                 = data_buf;
    assign  wstrb_o                 = 4'b1111;  // all bytes within 4 byte are valid
    assign  wlast_o                 = 1'b1;
    assign  wvalid_o                = wvalid;

    assign  bready_o                = 1'b1;

    assign  arvalid_o               = arvalid;
    assign  araddr_o                = src_addr;
    assign  arid_o                  = 4'd0;
    assign  arlen_o                 = 4'd0;     // 1-burst
    assign  arsize_o                = 3'b010;   // 4 bytes per transfer
    assign  arburst_o               = 2'b01;    // incremental

    assign  rready_o                = rready;


endmodule