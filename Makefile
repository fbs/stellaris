# Project name
NAME		= test

# Location of source files
# uartstdio is part of stellaris-ware utils, make uses vpath to find it.
C_SRC		+= $(wildcard *.c)
#C_SRC		+= uartstdio.c

# Optional ASM files
ASM_SRC		+= $(wildcard *.S)

# C flags
#CFLAGS		+=

# ASM flags
# AFLAGS	+=

# Linker flags
# LDFLAGS	+=

# Compiler tools prefix
PREFIX		= arm-none-eabi

# Path of the used linkerscript
LDSCRIPT	= linker.ld

# Processer variant
CPU		= cortex-m4
FPU		= fpv4-sp-d16 -mfloat-abi=softfp
PART		= LM4F120H5QR

# Location of the stellaris-ware directory
SW_DIR		= /data/build/stellaris/stellaris-ware

#################### DONT MODIFY ######################
#files
BIN		= $(BUILD_DIR)/$(NAME).bin
ELF		= $(BUILD_DIR)/$(NAME).elf
MAP		= $(BUILD_DIR)/$(NAME).map

# tools
CC		= $(PREFIX)-gcc
LD  		= $(PREFIX)-ld
OBJCPY		= $(PREFIX)-objcopy
SIZE		= $(PREFIX)-size
FLASH		= lm4flash
RM		= rm -rf
MKDIR		= mkdir -p

# paths
BUILD_DIR	= build

vpath 	%.c	src/
vpath	%.c	$(SW_DIR)/utils/ 

# Flags
INCLUDES	= -I$(SW_DIR)
DEBUGFLAGS	= -g #-D DEBUG

AFLAGS		+= -mthumb
AFLAGS		+= -mcpu=$(CPU)
AFLAGS		+= -mfpu=$(FPU)
AFLAGS		+= -MD

# C FLAGS
ifeq ($(DEBUG), true)
	CFLAGS		+= $(DEBUGFLAGS) 
endif
CFLAGS		+= -mthumb 
CFLAGS		+= -mcpu=$(CPU) 
CFLAGS		+= -mfpu=$(FPU) 
CFLAGS		+= -mfloat-abi=softfp 
CFLAGS		+= -Os 
CFLAGS		+= -ffunction-sections 
CFLAGS		+= -fdata-sections 
CFLAGS		+= -MD 
CFLAGS		+= -std=c99 
CFLAGS		+= -Wall 
CFLAGS		+= -pedantic 
CFLAGS		+= -DPART_$(PART)
CFLAGS		+= -DTARGET_IS_BLIZZARD_RA1
CFLAGS		+= $(INCLUDES)

# Linker flags
LDFLAGS		+= -T $(LDSCRIPT) 
LDFLAGS		+= --entry ResetISR 
LDFLAGS		+= --gc-sections
LDFLAGS		+= -nostdlib
ifeq ($(MAKE_MAP), true)
	LDFLAGS		+= -Map $(MAP)
endif

# Object files
OBJS		=  $(C_SRC:.c=.o)  
OBJS		+= $(ASM_SRC:.S=.o)
C_DEPS		=  $(wildcard *.d)

# Library locations
LIBS		+= $(SW_DIR)/driverlib/gcc-cm4f/libdriver-cm4f.a
LIBS		+= $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)
LIBS		+= $(shell $(CC) $(CFLAGS) -print-file-name=libc.a)
LIBS		+= $(shell $(CC) $(CFLAGS) -print-file-name=libm.a)

.PHONY: all clean

all: dir bin size

bin: build
	$(OBJCPY) -O binary $(ELF) $(BIN)

build: $(OBJS)
	$(LD) -o $(ELF) $(LDFLAGS) $(OBJS) $(LIBS)

clean:
	$(RM) $(OBJS) $(C_DEPS) $(BUILD_DIR)

dir:
	$(MKDIR) $(BUILD_DIR)

flash: bin
	$(FLASH) $(BIN)

size: bin
	$(SIZE) $(ELF)

# Compile 
.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

.S.o:
	$(CC) $(AFLAGS) -c $< -o $@

-include $(C_DEPS)
