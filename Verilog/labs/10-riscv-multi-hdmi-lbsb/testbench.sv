module testbench();
  logic        clk;
  logic [ 9:0]  leds;

  top dut (
    .CLOCK_27 (clk),
    .reset    (1'b0),
    .LEDR     (leds)
  );
    
  // initialize test
  initial
    begin
      $dumpfile("dump.vcd"); $dumpvars(0);
      // $monitor("%5t vaddr=%h vdata=%h vbyte=%b R=%h G=%h B=%h", $time, dut.vaddr, dut.vdata, dut.vbyte, dut.gpu.red, dut.gpu.green, dut.gpu.blue);
      $monitor("%5t LEDR=%b PC=%h instr=%h aluIn1=%h aluIn2=%h addr=%h writedata=%h memwrite=%b readdata=%h writeBackData=%h", $time, leds, dut.cpu.PC, dut.cpu.instr, dut.cpu.SrcA, dut.cpu.SrcB, dut.addr, dut.writedata, dut.memwrite, dut.readdata, dut.cpu.writeBackData);
      #10000 $writememh("riscv.out", dut.ram.RAM);
      $writememh("cpu_regs.out", dut.cpu.RegisterBank);
      $finish;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end
endmodule