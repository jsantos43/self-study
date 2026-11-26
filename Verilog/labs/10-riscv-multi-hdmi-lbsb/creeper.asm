# Rosto de creeper no frame buffer de 20x15 blocos (cada byte = XXRRGGBB)
#
#   1) pinta a tela inteira de verde (sw, 4 pixels por vez)
#   2) copia o sprite 6x6 do rosto byte a byte (lbu + sb)
#      para as linhas 4..9, colunas 7..12

.equ WIDTH,  20		# blocos por linha
.equ HEIGHT, 15		# linhas
.equ SPR,    6		# sprite de 6x6
.equ ROW0,   4		# linha onde o sprite comeca
.equ COL0,   7		# coluna onde o sprite comeca

.text	# 0x00000000
.globl _start
_start:
	# --- fundo verde ---
	la   a0, frame_buffer
	la   a1, frame_end
	li   t0, 0x19191919	# verde 00_01_10_01 nos 4 bytes
fill:
	sw   t0, 0(a0)
	addi a0, a0, 4
	bne  a0, a1, fill

	# --- sprite ---
	la   a0, sprite		# a0: origem (sprite)
	la   a1, frame_buffer + ROW0*WIDTH + COL0	# a1: inicio da linha no frame buffer
	li   t2, SPR		# t2: linhas restantes
row:
	li   t1, 0		# t1: coluna
col:
	lbu  t0, 0(a0)		# le um pixel do sprite
	add  t3, a1, t1
	sb   t0, 0(t3)		# escreve no frame buffer
	addi a0, a0, 1
	addi t1, t1, 1
	li   t4, SPR
	bne  t1, t4, col
	addi a1, a1, WIDTH	# proxima linha da tela
	addi t2, t2, -1
	bnez t2, row
end:
	j end

.data	# 0x00000200
.equ G, 0x19		# verde (R=01 G=10 B=01)
.equ K, 0x00		# preto
frame_buffer:
	.space WIDTH*HEIGHT
frame_end:
sprite:
	.byte K, K, G, G, K, K	# olhos
	.byte K, K, G, G, K, K
	.byte G, G, K, K, G, G	# nariz
	.byte G, K, K, K, K, G	# boca
	.byte G, K, K, K, K, G
	.byte G, K, G, G, K, G
