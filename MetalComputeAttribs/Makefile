.DEFAULT_GOAL := all

.PHONY: all
.PHONY: clean
.PHONY: test

XCRUN     = xcrun
CC        = clang++
RM        = rm -fr
DIR_GUARD = @mkdir -p $(@D)



METAL_SRC          = get_kernel_attribs.metal
MM_SRC             = get_metal_attrs.mm 
BIN_DIR            = cl_out/

SAMPLE_COMMANDLINE = 16777215 0 0 16384 1 1 1024 1 1

XCRUNCOMPILEFLAGS  = -sdk macosx metal
XCRUNLINKFLAGS     = -sdk macosx metallib
FRAMEWORKS         = -framework Metal -framework Foundation -framework CoreGraphics 
CCFLAGS            = -Wall -std=c++20 -stdlib=libc++ -O3 $(FRAMEWORKS)

METAL_BYTECODE = $(BIN_DIR)$(patsubst %.metal,%.air,      $(METAL_SRC))
METAL_LIB      = $(BIN_DIR)$(patsubst %.metal,%.metallib, $(METAL_SRC))
MM_BIN         = $(basename $(MM_SRC))
MM_BIN_PATH    = $(BIN_DIR)$(basename $(MM_SRC))

$(METAL_BYTECODE): $(METAL_SRC)
	$(DIR_GUARD)
	$(XCRUN) $(XCRUNCOMPILEFLAGS) -c $< -o $@

$(METAL_LIB): $(METAL_BYTECODE)
	$(DIR_GUARD)
	$(XCRUN) $(XCRUNLINKFLAGS) $< -o $@

$(MM_BIN_PATH): $(MM_SRC)
	$(DIR_GUARD)
	$(CC) $(CCFLAGS) $< -o $@

all:	$(MM_BIN_PATH) $(METAL_LIB)
	cd $(BIN_DIR); ./$(MM_BIN) $(SAMPLE_COMMANDLINE)

clean:
	-$(RM) $(BIN_DIR)


