LINUX_INCLUDE_DIR	= /opt/FriendlyARM/toolschain/4.4.3/include
TOPDIR=$(shell pwd)
UCOSPATH           = $(TOPDIR)/include

CROSS_COMPILE   = arm-linux-

#
# Include the make variables (CC, etc...)
#

AS              = $(CROSS_COMPILE)as
LD              = $(CROSS_COMPILE)ld
CC              = $(CROSS_COMPILE)gcc
CPP             = $(CC) -E
AR              = $(CROSS_COMPILE)ar
NM              = $(CROSS_COMPILE)nm
STRIP           = $(CROSS_COMPILE)strip
OBJCOPY         = $(CROSS_COMPILE)objcopy
OBJDUMP         = $(CROSS_COMPILE)objdump
export TOPDIR UCOSPATH CROSS_COMPILE AS LD CC \
	CPP AR NM STRIP OBJCOPY OBJDUMP MAKE

all: 	do-it-all
do-it-all:ucos

#
# standard CFLAGS
#

CPPFLAGS :=-I$(UCOSPATH) -I$(LINUX_INCLUDE_DIR)
#CFLAGS := $(CPPFLAGS) -Wall -Wstrict-prototypes -Wno-trigraphs -O2 \
#          -fomit-frame-pointer -fno-strict-aliasing -fno-common

#normal flags
CFLAGS := $(CPPFLAGS) -Wall -Wstrict-prototypes -g -Os -fomit-frame-pointer -ffreestanding
#CFLAGS := $(CPPFLAGS) -Wall -Wstrict-prototypes -O2 -fPIC -fomit-frame-pointer -ggdb 

AFLAGS :=$(CPPFLAGS)
export CPPFLAGS CFLAGS AFLAGS
CORE_FILES	= init/2440init.o init/main.o arm/arm.o lib/lib.o source/core.o yy/yy.o
SUBDIRS         = arm source lib yy


CLEAN_FILES = \
	ucos-elf \
	ucos \
	ucos.nm \
	ucos.map\
	ucos.t\
	ucos.d \
	ucos.bin \
	ucos.dis
#
# Location of the gcc arm libs.
#
ARM_GCC_LIBS	= /opt/FriendlyARM/toolschain/4.4.3/lib/gcc/arm-none-linux-gnueabi/4.4.3
ARM_GCC_LIB1	= /opt/FriendlyARM/toolschain/4.4.3/arm-none-linux-gnueabi/sys-root/usr/lib

OBJCOPYFLAGS = -R .comment -R .stab -R .stabstr

CLIBS = -L$(ARM_GCC_LIBS) -L$(ARM_GCC_LIB1) --start-group -lgcc -lgcc_eh -lgcov -lc --end-group

#laputa symbolic
LINKFLAGS = -T./ucos.lds -Bstatic
#LINKFLAGS = -T./ucos.lds 
ucos:init/2440init.o init/main.o linuxsubdirs
	$(LD) $(LINKFLAGS) $(CORE_FILES) -o ucos-elf
	$(NM)  -l ucos-elf > ucos.map
	$(OBJDUMP) -S ucos-elf > ucos.d
	$(OBJDUMP) -t ucos-elf > ucos.t
	$(OBJDUMP) -D -m arm  ucos-elf > ucos.dis
	$(OBJCOPY) -O binary -S ucos-elf ucos.bin

clean:
	find . \( -name '*.o' -o -name core -o -name ".*.flags" \) -type f -print \
	| grep -v lxdialog/ | xargs rm -f
	rm -f $(CLEAN_FILES)

distclean: clean
	rm -f $(DISTCLEAN_FILES)
linuxsubdirs: $(patsubst %, _dir_%, $(SUBDIRS))

$(patsubst %, _dir_%, $(SUBDIRS)) : 
	$(MAKE) CFLAGS="$(CFLAGS) $(CFLAGS_KERNEL)" -C $(patsubst _dir_%, %, $@)

init/main.o: init/main.c
	$(CC) $(CFLAGS) $(CFLAGS_KERNEL) $(PROFILING) -c -o $*.o $<
init/2440init.o:init/2440init.S
include Rules.make
