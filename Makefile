# Project name
NAME		= test

# Location of source files
# uartstdio is part of stellaris-ware utils, make uses vpath to find it.
C_SRC		+= $(subst $(SRC_DIR)/, , $(wildcard $(SRC_DIR)/*.c))
C_SRC		+= uartstdio.c

# Compiler tools prefix
PREFIX		= arm-none-eabi

# Path of the used linkerscript
LDSCRIPT	= linker.ld

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
SRC_DIR		= src

vpath 	%.c	src/
vpath	%.c	$(SW_DIR)/utils/ 

# Flags
INCLUDES	= -I$(SW_DIR)
DEBUGFLAGS	= -g #-D DEBUG

# C FLAGS
ifeq ($(DEBUG), true)
	CFLAGS		+= $(DEBUGFLAGS) 
endif
CFLAGS		+= -mthumb 
CFLAGS		+= -mcpu=cortex-m4 
CFLAGS		+= -mfpu=fpv4-sp-d16 
CFLAGS		+= -mfloat-abi=softfp 
CFLAGS		+= -Os 
CFLAGS		+= -ffunction-sections 
CFLAGS		+= -fdata-sections 
CFLAGS		+= -MD 
CFLAGS		+= -std=c99 
CFLAGS		+= -Wall 
CFLAGS		+= -pedantic 
CFLAGS		+= -DPART_LM4F120H5QR 
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
OBJS		= $(C_SRC:.c=.o)

# Library locations
LIBS		+= $(SW_DIR)/driverlib/gcc-cm4f/libdriver-cm4f.a
LIBS		+= $(shell $(CC) $(CFLAGS) -print-libgcc-file-name)
LIBS		+= $(shell $(CC) $(CFLAGS) -print-file-name=libc.a)
LIBS		+= $(shell $(CC) $(CFLAGS) -print-file-name=libm.a)

.PHONY: all clean
all: clean dir bin size

bin: build
	$(OBJCPY) -O binary $(ELF) $(BIN)

build: $(OBJS)
	$(LD) -o $(ELF) $(LDFLAGS) $(addprefix $(BUILD_DIR)/,$(OBJS)) $(LIBS)

clean:
	$(RM) $(OBJS) $(ELF) $(BIN) src/*.d $(BUILD_DIR)/*

dir:
	$(MKDIR) $(BUILD_DIR)

flash: bin
	$(FLASH) $(BIN)

size: bin
	$(SIZE) $(ELF)

# Compile 
.c.o:
	$(CC) $(CFLAGS) -c $< -o $(BUILD_DIR)/$@

