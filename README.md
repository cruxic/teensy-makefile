This Makefile compiles C/C++ code for a Teensy-LC USB development board without the Arduino IDE.

## Setup
The simplest way to get the latest Teensy compiler and core libraries is to install Arduino IDE and [the Teensyduino plugin](https://www.pjrc.com/teensy/td_download.html).  You will not be using the IDE, just the plugin.

Next, fix the three symlinks in ./Compiler.  They should point to:
  1. arm-bin -> /path/to/your/arduino-ide/hardware/tools/arm/bin/
  2. teensy3 -> /path/to/your/arduino-ide/hardware/teensy/avr/cores/teensy3
  3. teensy-tools -> /path/to/your/arduino-ide/hardware/tools

## Usage

To compile `program.hex`:

```bash
make
```
*Note: the first time this is run, it also compiles all the core teensy sources into teensy3.a*

Or, to compile and automatically launch the Teensy Loader:
```bash
make load
```

To clean all compiled files:
```bash
make clean
```


## Background
Finding the magical combination of programs and flags to create a working hex file was a very frustrating process.  The Makefile provided by PJRC (arduino/hardware/teensy/avr/cores/teensy3/Makefile) did not work for me because the linkage step silently ignored any undefined references.  The linker worked as it should when compiling from Arduino IDE.  So I set `build.verbose=true` in `~/.arduino15/preferences.txt` and was able to observe the exact compiling commands and create this Makefile.
