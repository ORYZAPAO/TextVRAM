# Makefile for Text VRAM simulation

# Tools
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

# Source files
SRCDIR = ./rtl
SRCS = $(SRCDIR)/vga_timing.v \
		 $(SRCDIR)/font_rom.v \
		 $(SRCDIR)/text_vram.v \
		 $(SRCDIR)/text_vram_top.v

BENCHDIR = ./bench
TB = $(BENCHDIR)/tb_text_vram.v

# Output files
OUT = tb_text_vram.vvp
VCD = tb_text_vram.vcd

.PHONY: all sim wave clean

all: sim

# Compile
$(OUT): $(SRCS) $(TB)
	$(IVERILOG) -o $(OUT) $(TB) $(SRCS)

# Run simulation
sim: $(OUT)
	$(VVP) $(OUT)

# View waveform
wave: sim
	$(GTKWAVE) $(VCD) &

# Clean
clean:
	rm -f $(OUT) $(VCD)
