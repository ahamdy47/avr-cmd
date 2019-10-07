# AVR Cmd Line Interface
# 
# -MakeLine [1.0]
#=======================
#  
# This makefile is designed as a minimal compiler/flasher interface
#
# 3 modes of operation + 2 for cleaning
# 
# mode 1: gen-lib creates a library called LIB_NAME from LIB_SRC sourc code directory in LIBS directory
# ex: win-make gen-lib LIB_SRC=uart-lib LIB_NAME=uart
# 
# mode 2: compile/flash with out libraries (bare-metal) from FILENAME
# note: MCU PART and PROG are predefined for specific chip and programmer based on avr-gcc and avrdude provided options
# ex: win-make compile FILENAME=demo
# 
# mode 3: compile-core/flash-core with libraries using LINK for multiples linking
# ex: win-make flash-core FILENAME=uart_lib LINK=-luart PART=m328pb
# 
# mode 4: clean-lib: deletes compiled library directory
#
# mode 5: clean: deletes compiled elf/hex files in root directory


MCU=atmega328p
PART=m328p 
PROG=atmelice_isp
F_CPU=16000000UL
FILENAME=uart_demo
LIB_SRC=uart-lib
LIBS=libraries
LIB_NAME=uart
LINK=-luart

.PHONY: flash-core compile-core
flash-core: compile-core
	avrdude -p $(PART) -c $(PROG) -U flash:w:$(FILENAME).hex

compile-core:
	if exist $(FILENAME).cpp avr-g++ -Os -std=gnu++11 -mmcu=$(MCU) -DF_CPU=$(F_CPU) $(FILENAME).cpp -o $(FILENAME).elf -I$(LIBS) -L$(LIBS) $(LINK)
	if exist $(FILENAME).c avr-gcc -Os -std=gnu11 -mmcu=$(MCU) -DF_CPU=$(F_CPU) $(FILENAME).c -o $(FILENAME).elf -I$(LIBS) -L$(LIBS) $(LINK)
	if exist $(FILENAME).elf avr-objcopy -O ihex $(FILENAME).elf $(FILENAME).hex

.PHONY: flash compile
flash: compile
	avrdude -p $(PART) -c $(PROG) -U flash:w:$(FILENAME).hex

compile:
	if exist $(FILENAME).cpp avr-g++ -Os -std=gnu++11 -mmcu=$(MCU) -DF_CPU=$(F_CPU) $(FILENAME).cpp -o $(FILENAME).elf
	if exist $(FILENAME).c avr-gcc -Os -std=gnu11 -mmcu=$(MCU) -DF_CPU=$(F_CPU) $(FILENAME).c -o $(FILENAME).elf
	if exist $(FILENAME).elf avr-objcopy -O ihex $(FILENAME).elf $(FILENAME).hex

.PHONY: gen-lib lib-obj lib-dir
gen-lib: lib-obj
	$(foreach file, $(wildcard $(LIBS)/$(LIB_SRC)/*.o), avr-ar rcs -o $(LIBS)/lib$(LIB_NAME).a $(file) &)

lib-obj: lib-dir
	$(foreach file, $(wildcard $(LIB_SRC)/*.c), avr-gcc -Os -std=gnu11 -mmcu=$(MCU) -DF_CPU=$(F_CPU) -c -I$(LIB_SRC) $(file) -o $(LIBS)/$(file).o &)
	$(foreach file, $(wildcard $(LIB_SRC)/*.cpp), avr-g++ -Os -std=gnu++11 -mmcu=$(MCU) -DF_CPU=$(F_CPU) -c -I$(LIB_SRC) $(file) -o $(LIBS)/$(file).o &)
	$(foreach file, $(wildcard $(LIB_SRC)/*.S), avr-gcc -c -g -x assembler-with-cpp -mmcu=$(MCU) -DF_CPU=$(F_CPU) -c -I$(LIB_SRC) $(file) -o $(LIBS)/$(file).o &)
	cd $(LIB_SRC) & $(foreach file, $(notdir $(wildcard $(LIB_SRC)/*.h)),  copy $(file) ..\$(LIBS)\$(file) &)

lib-dir:
	if exist $(LIBS)\$(LIB_SRC) rd /s /q $(LIBS)\$(LIB_SRC)
	if exist $(LIBS)\lib$(LIB_NAME).a del $(LIBS)\lib$(LIB_NAME).a
	mkdir $(LIBS)\$(LIB_SRC)

.PHONY: clean-all clean-lib clean-all
clean-all: clean 

clean-lib:
	if exist $(LIBS) rd /s /q $(LIBS)

clean:
	del *.elf *.hex