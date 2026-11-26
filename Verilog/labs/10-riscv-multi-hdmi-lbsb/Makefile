# http://iverilog.icarus.com/
CC=iverilog 
FLAGS=-Wall -g2012
# http://gtkwave.sourceforge.net/
VIEWER=code
# http://gtkwave.sourceforge.net/
# VIEWER=gtkwave
# https://github.com/yne/vcd
# VIEWER=../../../vcd/vcd < 
# https://drom.io/vcd/?github=menotti/up1/master/processor/dump.vcd

# Toolchain
# Ubuntu: riscv64-unknown-elf-*, Arch: riscv64-elf-*
CROSS  ?= $(shell command -v riscv64-unknown-elf-as >/dev/null && echo riscv64-unknown-elf || echo riscv64-elf)
AS      = $(CROSS)-as
LD      = $(CROSS)-ld
OBJCOPY = $(CROSS)-objcopy
OBJDUMP = $(CROSS)-objdump

# Arquivos
# Uso: make PROG=creeper  (monta creeper.asm -> creeper.hex; padrao: riscv)
PROG  ?= riscv
NAME   = $(basename $(PROG))
LDS    = riscv.ld
SRC    = $(NAME).asm
OBJ    = $(NAME).o
ELF    = $(NAME).elf
LST    = $(NAME).lst
HEX    = $(NAME).hex

all: $(HEX) $(LST) simul

# Monta o assembly (RV32)
$(OBJ): $(SRC)
	$(AS) -march=rv32i -o $@ $<

# Linka em 32 bits usando o linker script
$(ELF): $(OBJ) $(LDS)
	$(LD) -m elf32lriscv -T $(LDS) -o $@ $<

# Gera HEX de instruções + dados (.text + .data + .bss) (memória von Neumann)
$(HEX): $(ELF)
	$(OBJCOPY) -O verilog --verilog-data-width=4 $< $@

# Gera listagem com instruções + dados
$(LST): $(ELF)
	$(OBJDUMP) -D $< > $@
	@echo "Listagem gerada em $(LST)"

clean:
	rm -f $(OBJ) $(ELF) $(HEX) $(LST) *.out dump.vcd dump.log

simul: *.sv
	$(CC) -DSIM $(FLAGS) *.sv 
# 	vvp a.out | grep -v xxxx | sort > dump.log
# 	vvp a.out > dump.log
	vvp a.out 
# 	$(VIEWER) dump.vcd
# 	$(VIEWER) dump.vcd config.gtkw