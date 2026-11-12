module fibo (
  input clk, rst, enable, 
  inout tri [31:0] bus);
  integer value;

  always @(posedge clk) begin
    if (rst) begin
      value <= 1;
    end else begin
      // Se não estiver abilitado deve somar
      value <= enable ? value : value + bus;
    end
  end

  assign bus = enable ? value : 32'bZ;
endmodule