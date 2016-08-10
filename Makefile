#
# Compile a hex file for the Teensy-LC USB development board.
#

TEENSY_DIR := ./Compiler/teensy3
TEENSY_TOOLS_DIR := ./Compiler/teensy-tools

ARM_BIN := ./Compiler/arm-bin
CC := $(ARM_BIN)/arm-none-eabi-gcc
CXX := $(ARM_BIN)/arm-none-eabi-g++
AR := $(ARM_BIN)/arm-none-eabi-ar

#Shared C/C++ flags
CPPFLAGS := -c -Os -g -Wall -ffunction-sections -fdata-sections -nostdlib -MMD \
 -mthumb -mcpu=cortex-m0plus -fsingle-precision-constant \
 -D__MKL26Z64__ -DTEENSYDUINO=128 -DARDUINO=10608 -DF_CPU=48000000 \
 -DUSB_RAWHID -DLAYOUT_US_ENGLISH -I$(TEENSY_DIR)

#Flags only for C++
CXXFLAGS :=-fno-exceptions -felide-constructors -std=gnu++0x -fno-rtti

CORE_C_SOURCES := $(wildcard $(TEENSY_DIR)/*.c)
CORE_CPP_SOURCES := $(wildcard $(TEENSY_DIR)/*.cpp) 
CORE_ASM_SOURCES := $(wildcard $(TEENSY_DIR)/*.S) 
CORE_OBJS := $(CORE_C_SOURCES:.c=.o) $(CORE_CPP_SOURCES:.cpp=.o) $(CORE_ASM_SOURCES:.S=.o)

PROJ_C_SOURCES := $(wildcard ./*.c)
PROJ_CPP_SOURCES := $(wildcard ./*.cpp)
PROJ_OBJS := $(PROJ_C_SOURCES:.c=.o) $(PROJ_CPP_SOURCES:.c=.o)

default: program.hex

load: program.hex
	#Note: -file parameter is name of .hex file without extension
	$(TEENSY_TOOLS_DIR)/teensy_post_compile -file=program -path=. -tools=$(TEENSY_TOOLS_DIR) -board=TEENSYLC

program.hex: program.elf
	$(ARM_BIN)/arm-none-eabi-objcopy -O ihex -R .eeprom $< $@

program.elf: $(PROJ_OBJS) teensy3.a
	$(CC) -Os -Wl,--gc-sections,--relax,--defsym=__rtc_localtime=1470636289 "-T$(TEENSY_DIR)/mkl26z64.ld" \
	--specs=nano.specs -mthumb -mcpu=cortex-m0plus -fsingle-precision-constant \
	-o $@ $(PROJ_OBJS) teensy3.a -L$(TEENSY_DIR) -larm_cortexM0l_math -lm

teensy3.a: $(CORE_OBJS)
	rm -f $@
	$(AR) rcs $@ $^
	
#assembler rule
%.o: %.S
	$(CC) -x assembler-with-cpp $(CPPFLAGS) $< -o $@

clean:
	rm -f teensy3.a $(CORE_OBJS) $(PROJ_OBJS) program.elf program.hex
	
