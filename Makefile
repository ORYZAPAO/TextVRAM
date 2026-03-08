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

# AHB Bridge files
AHB_SRCS = $(SRCDIR)/ahb_text_vram_bridge.v \
		   $(SRCS)
AHB_TB = $(BENCHDIR)/tb_ahb_bridge.v

# Output files
OUT = tb_text_vram.vvp
VCD = tb_text_vram.vcd

AHB_OUT = tb_ahb_bridge.vvp
AHB_VCD = tb_ahb_bridge.vcd

.PHONY: all sim wave clean sim_ahb wave_ahb

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

# AHB Bridge compile
$(AHB_OUT): $(AHB_SRCS) $(AHB_TB)
	$(IVERILOG) -g2012 -o $(AHB_OUT) $(AHB_TB) $(AHB_SRCS)

# Run AHB Bridge simulation
sim_ahb: $(AHB_OUT)
	$(VVP) $(AHB_OUT)

# View AHB Bridge waveform
wave_ahb: sim_ahb
	$(GTKWAVE) $(AHB_VCD) &

# Clean
clean:
	rm -f $(OUT) $(VCD) $(AHB_OUT) $(AHB_VCD)
