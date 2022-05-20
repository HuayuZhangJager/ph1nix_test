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

# CC:=/opt/homebrew/bin/x86_64-elf-gcc
# AS:=/opt/homebrew/bin/x86_64-elf-as
# LD:=/opt/homebrew/bin/x86_64-elf-ld

# aarch64 to x86
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

$(BUILD)/%.o: $(SRC)/%.S
	$(MK_DIR_BUILD)
	$(AS) --32 -gstabs $< -o $@

$(BUILD)/%.out: $(BUILD).out
	$(LD) -m elf_i386 -static $^ -o $@

$(BUILD)/%.s: $(SRC)/%.c
	$(MK_DIR_BUILD)
	$(CC) $(CFLAGS) -S $< -o $@

.PHONY: test
test: $(BUILD)/params.s
