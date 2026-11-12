module top(
  input SYSCLOK,
  input [3:0] SW,
  input [0:0] KEY,
  output [6:0] HEX0
);

wire clk;
integer counter = 0;

always @(posedge SYSCLOK)
  counter <= counter + 1;

// Pega 1hz do clock de entrada
assign clk = counter[24];

reg [2:0] estado_atual = 3'b000;

always @(posedge clk) begin
  if (KEY[0]) begin // Se o botão for pressionado, carregue o estado informado para o estado atual(enable)
    estado_atual = SW[2:0];
  end else begin
    case (estado_atual) // Verifique o próximo estado com base no estado_atual
      3'b000: estado_atual <= SW[3] ? 3'b111 : 3'b001;
      3'b001: estado_atual <= SW[3] ? 3'b000 : 3'b011;
      3'b011: estado_atual <= SW[3] ? 3'b001 : 3'b101;
      3'b101: estado_atual <= SW[3] ? 3'b011 : 3'b111;
      3'b111: estado_atual <= SW[3] ? 3'b101 : 3'b000;
      3'b100: estado_atual <= 3'b000;
      3'b110: estado_atual <= 3'b000;
      3'b010: estado_atual <= 3'b000;
    endcase
  end
end

wire [6:0] segs;

dec7seg display({1'b0, estado_atual}, segs);

assign HEX0 = segs;

endmodule