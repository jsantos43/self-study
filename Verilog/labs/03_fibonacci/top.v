module top (
  input CLOCK_50,
  input [1:0] KEY,
  output [6:0] HEX1, HEX0);

  // Captar um 1hz do clock
  integer counter = 0;
  always @(posedge CLOCK_50)
    counter <= counter + 1;
  wire clk = counter[25];

  // Sequência fibonacci
  wire [31:0] fibonacci_bus;

  // Reset: botão KEY[0] pressionado (ativo-baixo) ou reinício automático em 89
  wire rst = ~KEY[0] | (fibonacci_bus > 89);

  // Lógica do barramento tri-state
  reg oe_a = 1;
  reg oe_b = 0; 
  always @(negedge clk) begin
    oe_a <= !oe_a;
    oe_b <= !oe_b;
  end
  
  fibo a(clk, rst, oe_a, fibonacci_bus);
  fibo b(clk, rst, oe_b, fibonacci_bus);

  // Converter binário para decimal
  wire [9:0] numero_bcd;
  bin2bcd conversor (fibonacci_bus[7:0], numero_bcd);

  // Converter decimal para display de 7 segmentos
  wire [6:0] segs1, segs2;
  dec7seg display1 (numero_bcd[3:0], segs1); // Unidades
  dec7seg display2 (numero_bcd[7:4], segs2); // Dezenas

  assign HEX0 = ~segs1;
  assign HEX1 = ~segs2;
endmodule
