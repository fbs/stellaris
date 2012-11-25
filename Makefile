NAME		= test
BIN		= $(NAME).bin
CC		= arm-none-eabi-gcc
LD  		= arm-none-eabi-ld
OBJCPY		= arm-none-eabi-objcopy
FLASH		= lm4flash

STARTUP		= startup_gcc.c
LINKERSCRIPT	= linker.ld
STELLARIS_DIR	= /data/build/stellaris/stellaris
C_SRC		= $(STARTUP) main.c

INCLUDE		= -I$(STELLARIS_DIR)
DEBUGFLAGS	= -g
CFLAGS		= $(DEBUGFLAGS) -mthumb -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=softfp -Os -ffunction-sections -fdata-sections -MD -std=c99 -Wall -pedantic -DPART_LM4F120H5QR -DTARGET_IS_BLIZZARD_RA1
LDFLAGS		= -T $(LINKERSCRIPT) --entry ResetISR --gc-sections
OBJS	 	= $(C_SRC:.c=.o)

.PHONY: all clean
all: bin

bin: build
	$(OBJCPY) -O binary $(NAME) $(BIN)

build: $(OBJS)
	$(LD) -o $(NAME) $(LDFLAGS) $(OBJS)

clean:
	rm -f $(OBJS) $(NAME) $(BIN) *.d

program: bin
	$(FLASH) $(BIN)

.c.o:
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@
