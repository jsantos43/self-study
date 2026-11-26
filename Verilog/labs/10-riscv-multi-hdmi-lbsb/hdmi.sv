module hdmi #(
  parameter
  WIDTH = 640, HEIGHT = 480, // 640 x 480 @ 25.2 MHz (negative)
  HFRONT = 16, HSYNC = 96, HBACK = 48, HPULSEN = 1,
  VFRONT = 10, VSYNC =  2, VBACK = 33, VPULSEN = 1
) (
  input clk, clk_tmds, reset, // clk: pixel (25.2 MHz), clk_tmds: 5x clk (126 MHz)
  input [7:0] pixel,          // XXRRGGBB
  output [31:0] vaddr,
  output tmds_clk_p, tmds_clk_n,
  output [2:0] tmds_d_p, tmds_d_n);

  reg hdmi_HS, hdmi_VS, hdmi_DA;

  reg [9:0] CounterX, CounterY;
  wire CounterXmaxed = (CounterX == (WIDTH + HFRONT + HSYNC + HBACK - 1));
  wire CounterYmaxed = (CounterY == (HEIGHT + VFRONT + VSYNC + VBACK - 1));

  wire [5:0] row = (CounterY>>5); // 32 pixels x
  wire [5:0] col = (CounterX>>5); // 32 pixels
  assign vaddr = col + (row<<4) + (row<<2); // addr = col + row x 20

  always @(posedge clk or posedge reset)
  if (reset) begin
    CounterX <= 10'b0;
    CounterY <= 10'b0;
  end
  else
  begin
    if (CounterXmaxed)
      CounterX <= 10'b0;
    else
      CounterX <= CounterX + 1'b1;

    if (CounterXmaxed)
      if(CounterYmaxed)
        CounterY <= 10'b0;
      else
        CounterY <= CounterY + 1'b1;

    hdmi_DA <= (CounterX < WIDTH) && (CounterY < HEIGHT);
    hdmi_HS <= HPULSEN[0] ^ (CounterX >= ( WIDTH + HFRONT) && (CounterX < ( WIDTH + HFRONT + HSYNC)));
    hdmi_VS <= VPULSEN[0] ^ (CounterY >= (HEIGHT + VFRONT) && (CounterY < (HEIGHT + VFRONT + VSYNC)));
  end

  // cada componente de 2 bits vira 8 bits (11 -> ff, 10 -> aa, 01 -> 55, 00 -> 00)
  wire [7:0] red   = {4{pixel[5:4]}};
  wire [7:0] green = {4{pixel[3:2]}};
  wire [7:0] blue  = {4{pixel[1:0]}};

  // codificacao TMDS (8b/10b); o canal 0 (azul) leva os sincronismos
  wire [9:0] tmds [0:2];
  tmds_encoder enc_b(clk, blue,  {hdmi_VS, hdmi_HS}, hdmi_DA, tmds[0]);
  tmds_encoder enc_g(clk, green, 2'b00,              hdmi_DA, tmds[1]);
  tmds_encoder enc_r(clk, red,   2'b00,              hdmi_DA, tmds[2]);

`ifndef SIM
  // serializadores 10:1 (DDR, bit 0 sai primeiro) + saidas diferenciais
  wire [3:0] ser;
  genvar c;
  generate
    for (c = 0; c < 3; c = c + 1) begin : g_ch
      OSER10 #(.GSREN("false"), .LSREN("true")) ser_d (
        .Q(ser[c]),
        .D0(tmds[c][0]), .D1(tmds[c][1]), .D2(tmds[c][2]), .D3(tmds[c][3]), .D4(tmds[c][4]),
        .D5(tmds[c][5]), .D6(tmds[c][6]), .D7(tmds[c][7]), .D8(tmds[c][8]), .D9(tmds[c][9]),
        .PCLK(clk), .FCLK(clk_tmds), .RESET(reset));
      TLVDS_OBUF obuf_d (.I(ser[c]), .O(tmds_d_p[c]), .OB(tmds_d_n[c]));
    end
  endgenerate

  // clock TMDS = clock do pixel (padrao 1111100000)
  OSER10 #(.GSREN("false"), .LSREN("true")) ser_clk (
    .Q(ser[3]),
    .D0(1'b1), .D1(1'b1), .D2(1'b1), .D3(1'b1), .D4(1'b1),
    .D5(1'b0), .D6(1'b0), .D7(1'b0), .D8(1'b0), .D9(1'b0),
    .PCLK(clk), .FCLK(clk_tmds), .RESET(reset));
  TLVDS_OBUF obuf_clk (.I(ser[3]), .O(tmds_clk_p), .OB(tmds_clk_n));
`else
  // na simulacao so os codificadores rodam
  assign tmds_clk_p = clk;    assign tmds_clk_n = ~clk;
  assign tmds_d_p   = 3'b000; assign tmds_d_n   = 3'b111;
`endif
endmodule

// Codificador TMDS (DVI 1.0, secao 3.2)
module tmds_encoder (
  input            clk,
  input      [7:0] din,   // dado de video
  input      [1:0] ctrl,  // {C1, C0} fora da area visivel
  input            de,    // data enable (area visivel)
  output reg [9:0] dout);

  // 1o estagio: minimiza transicoes (XOR ou XNOR)
  wire [3:0] n1d = din[0] + din[1] + din[2] + din[3] + din[4] + din[5] + din[6] + din[7];
  wire use_xnor = (n1d > 4'd4) || (n1d == 4'd4 && din[0] == 1'b0);

  wire [8:0] q_m;
  assign q_m[0] = din[0];
  genvar i;
  generate
    for (i = 1; i < 8; i = i + 1) begin : g_qm
      assign q_m[i] = use_xnor ? ~(q_m[i-1] ^ din[i]) : (q_m[i-1] ^ din[i]);
    end
  endgenerate
  assign q_m[8] = ~use_xnor;

  // 2o estagio: balanceamento DC
  wire [3:0] n1q = q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7];
  wire [3:0] n0q = 4'd8 - n1q;
  wire signed [4:0] diff = $signed({1'b0, n1q}) - $signed({1'b0, n0q}); // n1q - n0q
  reg  signed [5:0] cnt = 0;

  always @(posedge clk)
    if (!de) begin
      cnt <= 0;
      case (ctrl)
        2'b00: dout <= 10'b1101010100;
        2'b01: dout <= 10'b0010101011;
        2'b10: dout <= 10'b0101010100;
        2'b11: dout <= 10'b1010101011;
      endcase
    end
    else if (cnt == 0 || diff == 0) begin
      dout <= {~q_m[8], q_m[8], q_m[8] ? q_m[7:0] : ~q_m[7:0]};
      cnt  <= q_m[8] ? cnt + diff : cnt - diff;
    end
    else if ((cnt > 0 && diff > 0) || (cnt < 0 && diff < 0)) begin
      dout <= {1'b1, q_m[8], ~q_m[7:0]};
      cnt  <= cnt - diff + (q_m[8] ? 6'sd2 : 6'sd0);
    end
    else begin
      dout <= {1'b0, q_m[8], q_m[7:0]};
      cnt  <= cnt + diff - (q_m[8] ? 6'sd0 : 6'sd2);
    end
endmodule
