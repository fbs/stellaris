NAME		= test

#files
BIN		= $(BUILD_DIR)/$(NAME).bin
ELF		= $(BUILD_DIR)/$(NAME).elf
MAP		= $(BUILD_DIR)/$(NAME).map

# tools
PREFIX		= arm-none-eabi

CC		= $(PREFIX)-gcc
LD  		= $(PREFIX)-ld
OBJCPY		= $(PREFIX)-objcopy
FLASH		= lm4flash
RM		= rm -rf
MKDIR		= mkdir -p

# needed scripts
LDSCRIPT	= linker.ld

# paths
SW_DIR		= /data/build/stellaris/stellaris-ware/
BUILD_DIR		= build/
SRC_DIR		= src/

# Flags
INCLUDES	= -I$(SW_DIR)
DEBUGFLAGS	= -g -D DEBUG

CFLAGS		+= $(DEBUGFLAGS) 
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

LDFLAGS		+= -T $(LDSCRIPT) 
LDFLAGS		+= --entry ResetISR 
LDFLAGS		+= --gc-sections
LDFLAGS		+= -Map $(MAP)
LDFLAGS		+= -nostdlib

C_SRC		= $(wildcard src/*.c)
OBJS		= $(C_SRC:.c=.o)

LIBS		+= $(SW_DIR)/driverlib/gcc-cm4f/libdriver-cm4f.a
LIBS		+= ${shell ${CC} ${CFLAGS} -print-libgcc-file-name}
LIBS		+= ${shell ${CC} ${CFLAGS} -print-file-name=libc.a}
LIBS		+= ${shell ${CC} ${CFLAGS} -print-file-name=libm.a}

.PHONY: all clean
all: dir bin

bin: build
	$(OBJCPY) -O binary $(ELF) $(BIN)

build: $(OBJS)
	$(LD) -o $(ELF) $(LDFLAGS) $(OBJS) $(LIBS)

clean:
	$(RM) $(OBJS) $(ELF) $(BIN) src/*.d

dir:
	$(MKDIR) $(BUILD_DIR)

program: bin
	$(FLASH) $(BIN)

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

list: 
	echo $(C_SRC)
