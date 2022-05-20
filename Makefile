# *****+. =***+====+*Fk U Nvidia!!!***********
# *****+. =*++==++*+-+**----Linus Torvalds****
# *****+. ===+-...:-===+**********************
# *****+..=+*-:-------=++*********************
# *****+:.=*=--======--=++********************
# *****+:.=*==**#*=##*+=++********************
# *****+:.=++++**=:+++=-+*********************
# *****+:.=*=-=*%***===-+*********************
# *****+:.=++=*#%#**+++==+********************
# *****+:.-+=*#%%#*+++++**********************
# *****+:.-*#%%%%%#*++++**********************
# *****+:.-+#%%%%%%#**+==*********************
# *****+:.-+#%%%%%%#**+++-***#****************
# *****+-=+*#%%%%%%#**+*+.*#%######*#*********
# *******###%%%%%%%*==+==+*%%%######%#********
# ********#%%%%%%%#+=+===+*#%%######%%#*******
# ##%#######%%%%%%*=======*%%%%%%###%%%#******
# #%%%%%%%%+%%%%%%#=---::-+%%%%%%%%%%%%%******
# #%####%%+:#%%%%%%*---:.:-%%%%%%%%%%%%%#*****
# *##%%%%%-:+*%%%%%%=:::..:#%%%%%%%%@@%%%#****
# *#%%%%#%*---=+*%%%#-:...:*%%%%%%%%@@%%%%****
# **%###%%%*+===#@@@%=-::::=%%%%%@@@@@%%%%#***
# **###%%@@@%*+*#@@@%=--:::-%%%%@@@@@@@%%#%***
# ***#%@@@@@@%#*%@@@%=-:::--*%%@@@@@@@@@%%##**
# ***%%@@%@@@@@@@@@%#--..:--+%%%@@@@@@@@@@@%*+
# ***%%@@@@@@@@@@@%%*=-..:--=%%%@@@@@@@##%%%#+
# ***%@@@@@@@@@@@@%%+=:..:---#%%@@@@@@@%##%%%*

SRC=./src
BUILD:=./build
MK_DIR_BUILD:=mkdir -p $(BUILD)

# for Mac (not work for glibc like GNU stdio.h)
# CC:=/opt/homebrew/bin/x86_64-elf-gcc
# AS:=/opt/homebrew/bin/x86_64-elf-as
# LD:=/opt/homebrew/bin/x86_64-elf-ld

# aarch64 to x86 (kali linux aarch64)
CC:=/usr/bin/x86_64-linux-gnu-gcc
AS:=/usr/bin/x86_64-linux-gnu-as
NASM:=/usr/bin/nasm
LD:=/usr/bin/x86_64-linux-gnu-ld


CFLAGS:= -m32
# CFLAGS+= -fno-builtin # no built-in function in gcc
CFLAGS+= -fno-pic # no position independent code
# CFLAGS+= -fno-pie # no position independent excutable
# CFLAGS+= -fno-stack-protector # no stack protector
CFLAGS+= -fno-asynchronous-unwind-tables # no CFI (Call Frame Information)
# CFLAGS+= -nostdinc # no standard header
# CFLAGS+= -nostdlib # no standard library
CFLAGS+= -Qn # no gcc version info
CFLAGS+= -mpreferred-stack-boundary=2 # no stack align
# CFLAGS+= -fomit-frame-pointer # no stack frame
CFLAGS:=$(strip ${CFLAGS})

.PHONY: clean
clean:
	rm -rf $(BUILD)

# for GAS (GNU AS)
$(BUILD)/%.o: $(SRC)/%.S
	$(MK_DIR_BUILD)
	$(AS) --32 -gstabs $< -o $@

# for NASM
$(BUILD)/%.o: $(SRC)/%.asm
	$(MK_DIR_BUILD)
	$(NASM) -f elf32 -gdwarf $< -o $@

$(BUILD)/%.out: $(BUILD)/%.o
	$(LD) -m elf_i386 -static $^ -o $@

$(BUILD)/%.s: $(SRC)/%.c
	$(MK_DIR_BUILD)
	$(CC) $(CFLAGS) -S $< -o $@

.PHONY: test
test: $(BUILD)/call.o
