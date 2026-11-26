// Tang Nano 20K: RISC-V multiciclo com video HDMI (DVI) 640x480 @ 60 Hz
module top (
  input            CLOCK_27,  // 27MHz
  input            reset,     // botao S2 (ativo alto)
  output reg [9:0] LEDR,
  // HDMI: portas escalares (o nextpnr nao pareia bem LVDS em barramento)
  output           tmds_clk_p, tmds_clk_n,
  output           tmds_d0_p, tmds_d0_n,   // azul + HS/VS
  output           tmds_d1_p, tmds_d1_n,   // verde
  output           tmds_d2_p, tmds_d2_n);  // vermelho

  wire memwrite, clk, rst, por, halt;
  wire [ 3:0] writemask;
  wire [31:0] pc, instr;
  wire [31:0] writedata, addr, readdata;
  wire [31:0] vaddr, vdata;
  wire [ 7:0] vbyte = vaddr[1] ? (vaddr[0] ? vdata[31:24] : vdata[23:16])
                               : (vaddr[0] ? vdata[15: 8] : vdata[ 7: 0]);

  // clocks: pixel 25,2 MHz e TMDS 126 MHz (5x, serializacao DDR 10:1)
  wire clk_pix, clk_tmds, pll_lock;
  `ifdef SIM
  integer counter = 0;
  always @(posedge CLOCK_27)
    counter <= counter + 1;
  assign clk_pix  = counter[0];
  assign clk_tmds = CLOCK_27;
  assign pll_lock = 1'b1;
  `else
  // 27 MHz * (13+1) / (2+1) = 126 MHz; VCO = 126 * 4 = 504 MHz
  rPLL #(
    .FCLKIN("27"), .DEVICE("GW2AR-18C"),
    .IDIV_SEL(2), .FBDIV_SEL(13), .ODIV_SEL(4),
    .DYN_IDIV_SEL("false"), .DYN_FBDIV_SEL("false"), .DYN_ODIV_SEL("false"),
    .DYN_SDIV_SEL(2), .PSDA_SEL("0000"), .DUTYDA_SEL("1000"),
    .CLKFB_SEL("internal"), .CLKOUT_BYPASS("false"), .CLKOUTP_BYPASS("false"),
    .CLKOUTD_BYPASS("false"), .CLKOUTD_SRC("CLKOUT"), .CLKOUTD3_SRC("CLKOUT")
  ) pll (
    .CLKIN(CLOCK_27), .CLKOUT(clk_tmds), .LOCK(pll_lock),
    .CLKOUTP(), .CLKOUTD(), .CLKOUTD3(),
    .RESET(1'b0), .RESET_P(1'b0), .CLKFB(1'b0),
    .FBDSEL(6'b0), .IDSEL(6'b0), .ODSEL(6'b0),
    .PSDA(4'b0), .DUTYDA(4'b0), .FDLY(4'b0));

  CLKDIV #(.DIV_MODE("5"), .GSREN("false")) pixdiv (
    .HCLKIN(clk_tmds), .RESETN(pll_lock), .CALIB(1'b0), .CLKOUT(clk_pix));
  `endif

  // CPU, memoria e gerador de video no mesmo clock (o do pixel)
  assign clk = clk_pix;

  // power-on reset + botao + espera do PLL travar
  power_on_reset pwr(clk, por);
  assign rst = por | reset | ~pll_lock;

  // microprocessor
  riscvmulti cpu(clk, rst, addr, writedata, memwrite, readdata, writemask, halt);

  // memory
  mem ram(clk, memwrite, addr, writedata, readdata, writemask, 'h200 + vaddr, vdata);

  // HDMI controller
  hdmi gpu(clk_pix, clk_tmds, rst, vbyte, vaddr,
           tmds_clk_p, tmds_clk_n,
           {tmds_d2_p, tmds_d1_p, tmds_d0_p}, {tmds_d2_n, tmds_d1_n, tmds_d0_n});

  // memory-mapped i/o
  wire isIO  = addr[8]; // 0x0000_0100
  wire isRAM = !isIO;
  localparam IO_LEDS_bit = 2; // 0x0000_0104
  always @(posedge clk)
    if (memwrite & isIO) begin // memory-mapped I/O
      if (addr[IO_LEDS_bit])
        LEDR <= writedata;
    end
endmodule
