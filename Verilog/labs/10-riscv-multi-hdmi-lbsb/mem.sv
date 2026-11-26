module mem (
  input  logic        clk, we,
  input  logic [31:0] a, wd,
  output logic [31:0] rd,
  input  logic  [3:0] wm,
  input  logic [31:0] va,
  output logic [31:0] vd);

  // 256 words of 4 bytes
  // Na Tang Nano 20K (yosys + apicula) a escrita por byte na BSRAM grava
  // nos bytes errados da palavra (sb), entao a memoria vai para LUTRAM,
  // onde cada byte tem seu proprio write enable.
  (* ram_style = "distributed" *)
  logic [3:0][7:0] RAM [0:255];

  // initialize memory with instructions and data
  initial
    $readmemh("creeper.hex", RAM);

  // regular port (read/write, synchronous, byte-enable write mask)
  always_ff @(posedge clk)
  begin
    if (we) begin
      if (wm[0]) RAM[a[31:2]][0] <= wd[ 7: 0];
      if (wm[1]) RAM[a[31:2]][1] <= wd[15: 8];
      if (wm[2]) RAM[a[31:2]][2] <= wd[23:16];
      if (wm[3]) RAM[a[31:2]][3] <= wd[31:24];
    end
    rd <= RAM[a[31:2]];
  end

  // video port (read only)
  always_ff @(posedge clk)
    vd <= RAM[va[31:2]];
endmodule
